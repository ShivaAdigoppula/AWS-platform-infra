terraform {
  backend "s3" {
    bucket         = "tfstate-958317380912-euc1"
    key            = "global/terraform.tfstate" # its own state, separate from every env
    region         = "eu-central-1"
    encrypt        = true
    use_lockfile   = true
    dynamodb_table = "terraform-locks"
  }
}