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
  description = "AWS region to deploy resources in."
  default     = "us-east-1"
}

variable "public_key_path" {
  description = "Path to your SSH public key."
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_type" {
  description = "EC2 instance type."
  default     = "t4g.micro"
}
