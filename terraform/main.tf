provider "aws" {
  region = var.aws_region
}

# 1. Custom VPC
resource "aws_vpc" "epicbook_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "epicbook-custom-vpc"
  }
}

# 2. Internet Gateway (Required to reach the internet)
resource "aws_internet_gateway" "epicbook_igw" {
  vpc_id = aws_vpc.epicbook_vpc.id
}

# 3. Public Subnet
resource "aws_subnet" "epicbook_public_subnet" {
  vpc_id                  = aws_vpc.epicbook_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # Critical for cloud access
  availability_zone       = "${var.aws_region}a"
}

# 4. Route Table & Association
resource "aws_route_table" "epicbook_rt" {
  vpc_id = aws_vpc.epicbook_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.epicbook_igw.id
  }
}

resource "aws_route_table_association" "epicbook_rta" {
  subnet_id      = aws_subnet.epicbook_public_subnet.id
  route_table_id = aws_route_table.epicbook_rt.id
}

# 5. Security Group (Fixed: Added vpc_id)
resource "aws_security_group" "epicbook_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow web traffic and restricted SSH"
  vpc_id      = aws_vpc.epicbook_vpc.id # Linked to your custom VPC

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

# 6. EC2 Instance (Fixed: Added subnet_id)
resource "aws_instance" "epicbook_server" {
  ami                    = "ami-05cf1e9f73fbad2e2"
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.epicbook_public_subnet.id # Place in custom subnet
  vpc_security_group_ids = [aws_security_group.epicbook_sg.id]

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