variable "name" {
  description = "Repository name, e.g. demo-app"
  type        = string
}

variable "keep_last_images" {
  description = "How many images to keep; older ones are deleted automatically"
  type        = number
  default     = 10
}

variable "force_delete" {
  description = "Allow terraform destroy even if the repo still contains images"
  type        = bool
  default     = false
}