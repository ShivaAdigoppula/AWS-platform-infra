module "vpc" {
  source = "../../modules/vpc"

  name               = "dev"
  cidr               = "10.10.0.0/16"
  azs                = ["eu-central-1a", "eu-central-1b"]
  single_nat_gateway = true
}

# Role the EKS control plane uses to manage AWS resources in our VPC
module "eks_cluster_role" {
  source = "../../modules/iam"

  name               = "dev-eks-cluster-role"
  service_principals = ["eks.amazonaws.com"]
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  ]
}

# Role the EC2 worker nodes use
module "eks_node_role" {
  source = "../../modules/iam"

  name               = "dev-eks-node-role"
  service_principals = ["ec2.amazonaws.com"]
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",          # join the cluster
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",               # give pods VPC IP addresses
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly", # pull images from ECR (pull only, no push)
  ]
}