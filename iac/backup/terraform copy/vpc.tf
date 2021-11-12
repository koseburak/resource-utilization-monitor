# vpc.tf | VPC Configuration

resource "aws_vpc" "vpc" {
    cidr_block              = var.vpc_cidr_block
    enable_dns_hostnames    = var.vpc_dns_hostnames
    enable_dns_support      = var.vpc_dns_support

    tags = {
        Name        = "${var.app_name}-vpc"
        Environment = "${var.app_name}-${var.app_env}"
    }
}