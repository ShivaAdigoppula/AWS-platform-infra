variable "name" {
  description = "Cluster name, e.g. dev-eks"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version (must be in standard support)"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the control plane and the nodes"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "IAM role the EKS control plane assumes"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role the worker nodes assume"
  type        = string
}

variable "public_access_cidrs" {
  description = "IPs allowed to reach the Kubernetes API (IAM login still required)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "capacity_type" {
  description = "ON_DEMAND or SPOT"
  type        = string
  default     = "ON_DEMAND"
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 3
}