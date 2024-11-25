terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_type_arm64" {
  description = "EC2 instance type for ARM64 architecture"
  type        = string
  default     = "t4g.micro"
}

variable "vpn_connection_port" {
  description = "Port for VPN connection"
  type        = number
  default     = 1194
}
