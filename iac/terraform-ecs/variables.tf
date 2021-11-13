# Global Variables
###################################################################################
variable "aws_profile" {
    type        = string
    default     = "default"
    description = "Profile name to access the AWS"
}

variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "aws_region" {
    type        = string
    default     = "eu-west-2"
    description = "AWS Region"
}

variable "availability_zones" {
    type        = list
    description = "List of availability zones"
}

variable "app_name" {
    type        = string
    description = "Application Name"
}

variable "app_env" {
    type        = string
    description = "Application Environment"
}


# Other Variables
###################################################################################

variable "vpc_cidr_block" {
    type        = string
    description = "CIDR block for the VPC"
}

variable "vpc_dns_support" {
    type        = bool
    description = "Enable DNS Support for VPC"
}

variable "vpc_dns_hostnames" {
    type        = bool
    description = "Enable DNS Hostnames for VPC"
}


variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "ecr_url" {
  type = string
  description = "Elastic Container Repository Url"  
}