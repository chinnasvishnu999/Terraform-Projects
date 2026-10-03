# AWS Infrastructure with Terraform & HCP

A structured collection of production-ready AWS Infrastructure as Code (IaC) projects managed via HCP Terraform and VCS-driven Git workflows.

## Repository Structure

- **[aws-s3-storage](./aws-s3-storage):** S3 bucket provisioning with dynamic randomized naming, tag management, and lifecycle configurations.
- **[aws-vpc-network](./aws-vpc-network):** Multi-AZ VPC architecture with public/private subnets, Internet Gateways, NAT Gateways, and route tables.
- **[aws-ec2-compute](./aws-ec2-compute):** EC2 instance deployment with custom Security Groups, IAM instance profiles, and user-data boot provisioning.

## CI/CD Workflow
- Infrastructure runs are managed using **HCP Terraform (Remote Execution)**.
- Commits to `main` trigger automated plans and controlled applies.