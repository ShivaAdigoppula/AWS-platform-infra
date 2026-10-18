variable "admin_cidrs" {
  description = "Your public IP(s) in CIDR form, e.g. 203.0.113.10/32"
  type        = list(string)
}

variable "github_webhook_cidrs" {
  description = "GitHub webhook source ranges (check https://api.github.com/meta -> hooks)"
  type        = list(string)
  default = [
    "192.30.252.0/22",
    "185.199.108.0/22",
    "140.82.112.0/20",
    "143.55.64.0/20",
  ]
}