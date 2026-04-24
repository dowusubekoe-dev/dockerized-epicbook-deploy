# Define the Security Group
provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "epicbook_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "epicbook-vpc" }
}

resource "aws_subnet" "epicbook_subnet" {
  vpc_id                  = aws_vpc.epicbook_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags                    = { Name = "epicbook-public-subnet" }
}

resource "aws_internet_gateway" "epicbook_igw" {
  vpc_id = aws_vpc.epicbook_vpc.id
  tags   = { Name = "epicbook-igw" }
}

resource "aws_route_table" "epicbook_rt" {
  vpc_id = aws_vpc.epicbook_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.epicbook_igw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.epicbook_subnet.id
  route_table_id = aws_route_table.epicbook_rt.id
}

resource "aws_security_group" "epicbook_sg" {
  name        = "epicbook-production-sg"
  vpc_id      = aws_vpc.epicbook_vpc.id
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
  subnet_id              = aws_subnet.epicbook_subnet.id
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