terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ECR
module "ecr_backend" {
  source = "../../modules/ecr"

  repository_name = "shopeasy-backend"

  tags = {
    Environment = "dev"
    Project     = "shopeasy"
    ManagedBy   = "terraform"
  }
}

module "ecr_frontend" {
  source = "../../modules/ecr"

  repository_name = "shopeasy-frontend"

  tags = {
    Environment = "dev"
    Project     = "shopeasy"
    ManagedBy   = "terraform"
  }
}

# VPC
module "vpc" {
  source = "../../modules/vpc"

  cluster_name = "shopeasy"
  vpc_cidr     = "10.0.0.0/16"

  tags = {
    Environment = "dev"
    Project     = "shopeasy"
    ManagedBy   = "terraform"
  }
}

# EKS
module "eks" {
  source = "../../modules/eks"

  cluster_name       = "shopeasy"
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  instance_type = "t3.small"
  desired_size  = 2
  min_size      = 1
  max_size      = 3

  tags = {
    Environment = "dev"
    Project     = "shopeasy"
    ManagedBy   = "terraform"
  }
}
