provider "aws" {
  region = var.aws_region
}

# Security Group: HTTP, HTTPS, and Restricted SSH
resource "aws_security_group" "epicbook_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow web traffic and restricted SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

# EC2 Instance Provisioning
resource "aws_instance" "epicbook_server" {
  ami           = "ami-0e2c8ccd4e1ffc3c5" # Ubuntu 24.04 LTS (Verify for your region)
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.epicbook_sg.id]

  # User Data Script to automate Docker setup
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y ca-certificates curl gnupg
              install -m 0755 -d /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
              chmod a+r /etc/apt/keyrings/docker.gpg
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
              apt-get update
              apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
              systemctl enable docker
              systemctl start docker
              usermod -aG docker ubuntu
              EOF

  tags = {
    Name = var.project_name
  }
}