terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # State file S3 mein store karo (production mein zaroori)
  # Abhi ke liye local state use kar rahe hain
  # backend "s3" {
  #   bucket = "shopeasy-terraform-state"
  #   key    = "dev/terraform.tfstate"
  #   region = "ap-south-1"
  # }
}

provider "aws" {
  region = var.aws_region
}

# Backend ECR
module "ecr_backend" {
  source = "../../modules/ecr"

  repository_name = "shopeasy-backend"

  tags = {
    Environment = "dev"
    Project     = "shopeasy"
    ManagedBy   = "terraform"
  }
}

# Frontend ECR
module "ecr_frontend" {
  source = "../../modules/ecr"

  repository_name = "shopeasy-frontend"

  tags = {
    Environment = "dev"
    Project     = "shopeasy"
    ManagedBy   = "terraform"
  }
}
