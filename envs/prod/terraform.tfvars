environment        = "prod"
vpc_cidr           = "10.30.0.0/16"
azs                = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
single_nat_gateway = false
kubernetes_version = "1.35"

node_instance_types = ["t3.large"]
node_desired_size   = 3
node_min_size       = 3
node_max_size       = 6