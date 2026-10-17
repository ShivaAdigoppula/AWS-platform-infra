output "role_arn" {
  description = "ARN of the role (other resources reference roles by ARN)"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of the role"
  value       = aws_iam_role.this.name
}

output "instance_profile_name" {
  description = "Instance profile name, or null if not created"
  value       = one(aws_iam_instance_profile.this[*].name)
}