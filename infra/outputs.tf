output "service_url" {
  description = "Public URL of the load balancer"
  value       = "http://${aws_lb.main.dns_name}"
}

output "ecr_repository_url" {
  description = "Repository the image must be pushed to"
  value       = aws_ecr_repository.app.repository_url
}

output "database_endpoint" {
  description = "Address of the PostgreSQL instance"
  value       = aws_db_instance.main.address
}
