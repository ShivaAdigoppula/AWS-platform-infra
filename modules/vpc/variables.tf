variable "name" {
  description = "Environment name, used in resource names (e.g. dev)"
  type        = string
}

variable "cidr" {
  description = "IP range of the whole VPC, e.g. 10.10.0.0/16"
  type        = string
}

variable "azs" {
  description = "Availability zones to spread subnets across (at least 2 for EKS)"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "true = one shared NAT (cheap, dev). false = one NAT per AZ (highly available, prod)"
  type        = bool
  default     = true
}