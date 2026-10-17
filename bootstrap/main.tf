# Reads your account ID (creates nothing).
data "aws_caller_identity" "current" {}

# 1. The bucket that stores every environment's state.
resource "aws_s3_bucket" "tfstate" {
  bucket = "tfstate-${data.aws_caller_identity.current.account_id}-euc1"

  lifecycle {
    prevent_destroy = true
  }
}

# 2. Keep every old version of every state file.
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Encrypt everything stored in the bucket.
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

# 4. Block every form of public access.
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 5. The lock table.
resource "aws_dynamodb_table" "locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}