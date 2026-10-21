environment        = "prod"
vpc_cidr           = "10.30.0.0/16"
azs                = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
single_nat_gateway = false
kubernetes_version = "1.35"

node_instance_types = ["t3.large"]
node_desired_size   = 3
node_min_size       = 3
node_max_size       = 6
cluster_admin_arns = [
  "arn:aws:iam::958317380912:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_f17701fceb99f840",
  "arn:aws:iam::958317380912:role/jenkins-role",
]

argocd_chart_version = "10.10.5"