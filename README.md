# AWS Infrastructure with Terraform & HCP

A structured collection of production-ready AWS Infrastructure as Code (IaC) projects managed via HCP Terraform and VCS-driven Git workflows.

## Repository Structure

- **[01-aws-s3-static-hosting](./01-aws-s3-static-hosting):** S3 bucket provisioning with dynamic randomized naming, tag management, and lifecycle configurations.
- **[02-custom-vpc-networking](./02-custom-vpc-networking):** Multi-AZ VPC architecture with public/private subnets, Internet Gateways, NAT Gateways, and route tables.
- **[03-ec2-web-server](./03-ec2-web-server):** EC2 instance deployment with custom Security Groups, IAM instance profiles, and user-data boot provisioning.

## CI/CD Workflow
- Infrastructure runs are managed using **HCP Terraform (Remote Execution)**.
- Commits to `main` trigger automated plans and controlled applies.
