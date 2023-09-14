# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    
  }
  # Backend - This bucket needs to create manually 
  backend "s3" {
    bucket = "tf-eks-15092023"
    key = "tf/terraform.tfstate"
    region = "us-east-1"
  }
}

# Terraform Provider Block
provider "aws" {
  region = var.aws_region
}