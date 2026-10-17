variable "name" {
  description = "Role name. IAM is global, so include the environment (e.g. dev-eks-node-role)"
  type        = string
}

variable "service_principals" {
  description = "AWS services allowed to assume this role (trust policy), e.g. [\"ec2.amazonaws.com\"]"
  type        = list(string)
}

variable "managed_policy_arns" {
  description = "AWS managed policies to attach (permissions)"
  type        = list(string)
  default     = []
}

variable "create_instance_profile" {
  description = "true only for roles used by EC2 instances directly (e.g. Jenkins on Day 2)"
  type        = bool
  default     = false
}