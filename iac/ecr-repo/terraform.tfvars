# aws access variables
aws_profile       = "eks-beginner"
aws_access_key    = "AKIARJOPXHLEL6SHDFA5"
aws_secret_key    = "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"

# region, availability zones and subnets variables
aws_region          = "eu-west-2"
availability_zones  = [ "eu-west-2a", "eu-west-2b", "eu-west-2c" ]
vpc_cidr_block      = "10.0.0.0/16"
vpc_dns_support     = true
vpc_dns_hostnames   = true
public_subnets      = [ "10.0.100.0/24", "10.0.101.0/24" ]
private_subnets     = [ "10.0.0.0/24", "10.0.1.0/24" ]

# tag variables
app_name            = "observer"
app_env             = "prod"

ecr_url             = "089019333320.dkr.ecr.eu-west-2.amazonaws.com/observer"