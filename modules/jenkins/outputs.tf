output "public_ip" {
  value = aws_eip.this.public_ip
}

output "jenkins_url" {
  value = "http://${aws_eip.this.public_ip}:8080"
}

output "sonarqube_url" {
  value = "http://${aws_eip.this.public_ip}:9000"
}

output "instance_id" {
  description = "Use with Session Manager"
  value       = aws_instance.this.id
}