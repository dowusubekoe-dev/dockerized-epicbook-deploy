output "public_ip" {
  value       = aws_instance.epicbook_server.public_ip
  description = "The public IP of the EpicBook server"
}

output "ssh_command" {
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.epicbook_server.public_ip}"
  description = "Command to SSH into the instance"
}