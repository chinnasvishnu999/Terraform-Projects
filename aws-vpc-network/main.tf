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

# 1. Custom VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "portfolio-custom-vpc"
    Project     = "aws-vpc-network"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 2. Internet Gateway (Enables Internet access for the VPC)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "portfolio-igw"
    Project     = "aws-vpc-network"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 3. Public Subnets across 2 AZs
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "portfolio-public-subnet-${count.index + 1}"
    Project     = "aws-vpc-network"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 4. Public Route Table (Routes default traffic 0.0.0.0/0 to IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name        = "portfolio-public-rt"
    Project     = "aws-vpc-network"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 5. Associate Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
