Terraform AWS Prod-Ready 
Artem (whosthefunkyy) 
DevOps Engineer | Terraform | AWS | IaC

**Production-grade AWS infrastructure as code** using Terraform modules.

Deploy a **fully scalable web application** with:
- VPC (public/private subnets, NAT, IGW)
- Auto Scaling Group (EC2)
- Application Load Balancer (ALB)
- RDS (MySQL/PostgreSQL)
- Security Groups
- Remote state with S3 + DynamoDB locking

## Architecture
folder (main,outputs,variable)
    ├── modules/
    │   ├── network/vpc/
    │   ├── asg/
    │   ├── alb/
    │   ├── rds/
    │   └── sg/
        └── ec2/
    ├── prod/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variable.tf
    └── README.md

Features

Modular Design - "Reusable modules (vpc, asg, alb, rds, sg)"
Production Ready - "Multi-AZ, Auto Scaling, Health Checks, Private DB"
State Management - S3 backend + DynamoDB locking
Secure - "No hard-coded secrets, least privilege SGs"