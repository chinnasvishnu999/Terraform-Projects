terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Look up the custom VPC created by aws-vpc-network
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["portfolio-custom-vpc"]
  }
}

# 2. Look up the public subnet in AZ 1
data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["portfolio-public-subnet-1"]
  }
}

# 3. Look up the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 4. Security Group (Allows Inbound HTTP and all Outbound)
resource "aws_security_group" "web_sg" {
  name        = "portfolio-web-sg"
  description = "Allow inbound HTTP traffic and outbound access"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "portfolio-web-sg"
    Project     = "aws-ec2-compute"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 5. EC2 Web Server Instance
resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  # Cloud-init user script to install and launch an Apache web server
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Cloud Infrastructure Deployed via HCP Terraform</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name        = "portfolio-web-server"
    Project     = "aws-ec2-compute"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
