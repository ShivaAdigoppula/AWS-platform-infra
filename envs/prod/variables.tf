variable "environment" {
  description = "Environment name: dev, stage or prod"
  type        = string
}

variable "vpc_cidr" {
  description = "IP range of this environment's VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "true = one shared NAT (cheap), false = one per AZ (highly available)"
  type        = bool
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
}

variable "node_instance_types" {
  type = list(string)
}

variable "node_desired_size" {
  type = number
}

variable "node_min_size" {
  type = number
}

variable "node_max_size" {
  type = number
}
variable "cluster_admin_arns" {
  description = "IAM principals that are Kubernetes cluster-admins (you + Jenkins)"
  type        = list(string)
}

variable "argocd_chart_version" {
  description = "argo-cd Helm chart version for this environment"
  type        = string
}