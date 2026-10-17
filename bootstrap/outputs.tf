output "state_bucket" {
  description = "Name of the S3 bucket holding Terraform state"
  value       = aws_s3_bucket.tfstate.bucket
}

output "lock_table" {
  description = "Name of the DynamoDB lock table"
  value       = aws_dynamodb_table.locks.name
}