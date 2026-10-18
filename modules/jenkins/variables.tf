variable "name" {
  description = "Name prefix for the server's resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC to place the server in"
  type        = string
}

variable "subnet_id" {
  description = "PUBLIC subnet for the server"
  type        = string
}

variable "instance_type" {
  description = "t3.large: Jenkins + SonarQube need ~8 GB RAM together"
  type        = string
  default     = "t3.large"
}

variable "instance_profile_name" {
  description = "Instance profile that gives the server its IAM role"
  type        = string
}

variable "admin_cidrs" {
  description = "Your IP(s): may open the Jenkins and SonarQube UIs"
  type        = list(string)
}

variable "webhook_cidrs" {
  description = "GitHub's webhook IP ranges: may reach Jenkins on 8080"
  type        = list(string)
}

variable "volume_size" {
  description = "Disk size in GB (Jenkins workspaces + Docker images)"
  type        = number
  default     = 30
}