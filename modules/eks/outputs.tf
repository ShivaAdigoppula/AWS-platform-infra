output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "oidc_issuer_url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}
output "cluster_ca_certificate" {
  description = "Cluster's CA certificate (base64). Clients use it to trust the API server's HTTPS"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}