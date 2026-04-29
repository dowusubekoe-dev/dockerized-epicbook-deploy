variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "Name of the existing AWS Key Pair"
}

variable "my_ip" {
  type        = string
  description = "Your public IP address for SSH access (e.g., 1.2.3.4/32)"
}

variable "project_name" {
  default = "epicbook-deployment"
}