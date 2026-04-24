# Define the Security Group
provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "epicbook_sg" {
  name        = "epicbook-production-sg"
  description = "Allow SSH and Web traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"] # Restrict to your IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Provision the EC2 Instance
resource "aws_instance" "epicbook_server" {
  ami                    = "ami-04680790a315cd58d" # Ubuntu 22.04 LTS (Update for your region)
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.epicbook_sg.id]

  tags = {
    Name = var.project_name
  }

  # Bootstrap: Install Docker and Docker Compose automatically
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
              sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              EOF
}