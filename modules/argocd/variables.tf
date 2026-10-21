variable "chart_version" {
  description = "Version of the official argo-cd Helm chart (pinned, upgraded deliberately)"
  type        = string
}

variable "gitops_repo_url" {
  description = "Git repo Argo CD watches"
  type        = string
}

variable "gitops_revision" {
  description = "Branch/tag Argo CD follows"
  type        = string
  default     = "main"
}

variable "apps_path" {
  description = "Folder in the gitops repo with this environment's Application files, e.g. apps/dev"
  type        = string
}