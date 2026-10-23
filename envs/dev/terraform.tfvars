environment        = "dev"
vpc_cidr           = "10.10.0.0/16"
azs                = ["eu-central-1a", "eu-central-1b"]
single_nat_gateway = true
kubernetes_version = "1.35" # <- use the same version you used in Block 5

node_instance_types = ["t3.medium"]
node_desired_size   = 2
node_min_size       = 1
node_max_size       = 3
cluster_admin_arns = [
  "arn:aws:iam::958317380912:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_f17701fceb99f840",
  "arn:aws:iam::958317380912:role/jenkins-role",
]

argocd_chart_version = "10.10.5" # <- the version from Artifact Hub
eks_public_access_cidrs = [
  "18.194.166.29/32",  # Jenkins server (Elastic IP)
  "YOUR.LAPTOP.IP/32", # my laptop: update via PR when my IP changes
]