resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = "IMMUTABLE" # a pushed tag can never be overwritten
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = true # AWS scans each image for known vulnerabilities
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

# Housekeeping: keep only the newest N images
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep only the last ${var.keep_last_images} images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = var.keep_last_images
      }
      action = { type = "expire" }
    }]
  })
}