terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.74.1"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.AWS_REGION
}