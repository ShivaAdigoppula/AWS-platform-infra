module "vpc" {
  source = "../../modules/vpc"

  name               = "dev"
  cidr               = "10.10.0.0/16"
  azs                = ["eu-central-1a", "eu-central-1b"]
  single_nat_gateway = true
}