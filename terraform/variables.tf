variable "aws_region" {
  description = "AWS region to deploy the EpicBook VM"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair created in AWS Console"
  type        = string
}

variable "my_ip" {
  description = "Your local public IP address for SSH restriction (e.g., 1.2.3.4)"
  type        = string
}

variable "project_name" {
  description = "Tag name for the infrastructure"
  type        = string
  default     = "the-epicbook"
}