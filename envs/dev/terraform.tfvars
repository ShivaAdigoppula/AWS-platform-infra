environment        = "dev"
vpc_cidr           = "10.10.0.0/16"
azs                = ["eu-central-1a", "eu-central-1b"]
single_nat_gateway = true
kubernetes_version = "1.35" # <- use the same version you used in Block 5

node_instance_types = ["t3.medium"]
node_desired_size   = 2
node_min_size       = 1
node_max_size       = 3