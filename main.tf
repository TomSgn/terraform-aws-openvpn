provider "aws" {
  region = var.aws_region
}

# Obtain the Amazon Linux 2 ARM64 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-arm64-gp2"]
  }

  owners = ["amazon"]
}

# SSH Public Key
resource "aws_key_pair" "vpn_key_pair" {
  key_name   = "vpn-key-pair"
  public_key = file(var.public_key_path)
}

# VPC
resource "aws_vpc" "vpn_vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpn-vpc"
  }
}

# Subnet
resource "aws_subnet" "vpn_subnet" {
  vpc_id                  = aws_vpc.vpn_vpc.id
  cidr_block              = "10.0.0.0/28"
  map_public_ip_on_launch = true

  tags = {
    Name = "vpn-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "vpn_igw" {
  vpc_id = aws_vpc.vpn_vpc.id

  tags = {
    Name = "vpn-igw"
  }
}

# Route Table
resource "aws_route_table" "vpn_route_table" {
  vpc_id = aws_vpc.vpn_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpn_igw.id
  }

  tags = {
    Name = "vpn-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "vpn_route_table_association" {
  subnet_id      = aws_subnet.vpn_subnet.id
  route_table_id = aws_route_table.vpn_route_table.id
}

# Security Group
resource "aws_security_group" "vpn_security_group" {
  name        = "vpn-security-group"
  description = "Allow SSH and VPN traffic"
  vpc_id      = aws_vpc.vpn_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "OpenVPN"
    from_port   = var.vpn_connection_port
    to_port     = var.vpn_connection_port
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpn-security-group"
  }
}

# EC2 Instance
resource "aws_instance" "vpn_instance" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type_arm64
  subnet_id                   = aws_subnet.vpn_subnet.id
  vpc_security_group_ids      = [aws_security_group.vpn_security_group.id]
  key_name                    = aws_key_pair.vpn_key_pair.key_name
  associate_public_ip_address = true

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "vpn-instance"
  }
}
