variable "aws_region" {
  type        = string
  description = "AWS region for resources"
  default     = "us-east-1"
}

variable "bucket_prefix" {
  type        = string
  description = "Prefix for the S3 bucket name"
  default     = "portfolio-demo"
}
