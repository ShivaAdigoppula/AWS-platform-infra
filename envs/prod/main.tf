module "vpc" {
  source = "../../modules/vpc"

  name               = var.environment
  cidr               = var.vpc_cidr
  azs                = var.azs
  single_nat_gateway = var.single_nat_gateway
}

module "eks_cluster_role" {
  source = "../../modules/iam"

  name               = "${var.environment}-eks-cluster-role"
  service_principals = ["eks.amazonaws.com"]
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  ]
}

module "eks_node_role" {
  source = "../../modules/iam"

  name               = "${var.environment}-eks-node-role"
  service_principals = ["ec2.amazonaws.com"]
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly",
  ]
}

module "eks" {
  source = "../../modules/eks"

  name               = "${var.environment}-eks"
  kubernetes_version = var.kubernetes_version

  subnet_ids       = module.vpc.private_subnet_ids
  cluster_role_arn = module.eks_cluster_role.role_arn
  node_role_arn    = module.eks_node_role.role_arn

  node_instance_types  = var.node_instance_types
  node_desired_size    = var.node_desired_size
  node_min_size        = var.node_min_size
  node_max_size        = var.node_max_size
  admin_principal_arns = var.cluster_admin_arns
  depends_on           = [module.eks_cluster_role, module.eks_node_role]
}
module "argocd" {
  source = "../../modules/argocd"

  chart_version   = var.argocd_chart_version
  gitops_repo_url = "https://github.com/ShivaAdigoppula/aws-platform-gitops.git"
  apps_path       = "apps/${var.environment}" # dev -> apps/dev, prod -> apps/prod

  # Needs the cluster, the nodes (pods must run somewhere) AND the access entries (to log in)
  depends_on = [module.eks]
}