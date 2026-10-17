# One shared repository: Jenkins builds an image ONCE,
# and the same image is promoted dev -> stage -> prod.
module "ecr_demo_app" {
  source = "../modules/ecr"

  name             = "demo-app"
  keep_last_images = 10
}

output "demo_app_repository_url" {
  value = module.ecr_demo_app.repository_url
}