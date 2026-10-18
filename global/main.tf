# One shared repository: Jenkins builds an image ONCE,
# and the same image is promoted dev -> stage -> prod.
module "ecr_demo_app" {
  source = "../modules/ecr"

  name             = "demo-app"
  keep_last_images = 10
}

output "demo_app_repository_url" {
  value = module.ecr_demo_app.repository_url
}

# ---------- Tools network (no NAT: Jenkins sits in a public subnet) ----------
module "tools_vpc" {
  source = "../modules/vpc"

  name               = "tools"
  cidr               = "10.0.0.0/16"
  azs                = ["eu-central-1a", "eu-central-1b"]
  enable_nat_gateway = false
}

# ---------- Jenkins' AWS identity ----------
module "jenkins_role" {
  source = "../modules/iam"

  name               = "jenkins-role"
  service_principals = ["ec2.amazonaws.com"]
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",          # TECH DEBT: split into plan/apply roles later
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", # browser terminal via Session Manager
  ]
  create_instance_profile = true
}

# ---------- The Jenkins + SonarQube server ----------
module "jenkins" {
  source = "../modules/jenkins"

  name                  = "jenkins"
  vpc_id                = module.tools_vpc.vpc_id
  subnet_id             = module.tools_vpc.public_subnet_ids[0]
  instance_profile_name = module.jenkins_role.instance_profile_name
  admin_cidrs           = var.admin_cidrs
  webhook_cidrs         = var.github_webhook_cidrs
}

output "jenkins_url" {
  value = module.jenkins.jenkins_url
}

output "sonarqube_url" {
  value = module.jenkins.sonarqube_url
}

output "jenkins_instance_id" {
  value = module.jenkins.instance_id
}