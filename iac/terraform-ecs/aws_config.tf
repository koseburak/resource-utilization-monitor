# aws_config.tf | Main Configuration

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.60"
    }
  }
}

provider "aws" {
    region = var.aws_region
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key

    default_tags {
        tags = {
            AppName = var.app_name
            Environment = var.app_env
            Terraform   = "true"
        }
    }
}