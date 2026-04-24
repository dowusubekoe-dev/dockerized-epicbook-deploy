# --- Connection Details ---

output "public_ip" {
  description = "The public IP address of the EpicBook server"
  value       = aws_instance.epicbook_server.public_ip
}

output "ssh_command" {
  description = "Command to connect to the instance via SSH"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.epicbook_server.public_ip}"
}

# --- Network Verification ---

output "vpc_id" {
  description = "The ID of the designated VPC created for this project"
  value       = aws_vpc.epicbook_vpc.id
}

output "app_url" {
  description = "The URL to access the EpicBook application"
  value       = "http://${aws_instance.epicbook_server.public_ip}"
}

output "api_health_url" {
  description = "The URL to verify the Backend Healthcheck via the Proxy"
  value       = "http://${aws_instance.epicbook_server.public_ip}/api/health"
}