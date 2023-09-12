# Define Local Values in Terraform
locals {
  common_tags = {
    environment = var.environment
  }
  eks_cluster_name = "${var.environment}-${var.cluster_name}"
  vpc_name = "${var.environment}-${var.vpc_name}"
} 