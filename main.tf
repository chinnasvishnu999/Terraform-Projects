terraform {
  required_version = ">= 1.5.0"

  cloud {
    organization = "Vishnuchinnas"

    workspaces {
      name = "Terraform-Projects"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# S3 bucket names must be globally unique across all AWS accounts,
# so we append a random string to avoid naming collisions.
# resource "random_id" "bucket_suffix" {
#   byte_length = 4
# }

# resource "aws_s3_bucket" "my_first_bucket" {
#   bucket = "terraform-learn-${random_id.bucket_suffix.hex}"

#   tags = {
#     Environment = "Learning"
#     ManagedBy   = "Terraform"
#   }
# }

# output "bucket_name" {
#   description = "The globally unique name of the bucket created"
#   value       = aws_s3_bucket.my_first_bucket.bucket
# }
