# aws access variables
aws_profile       = "<profile>"
aws_access_key    = "<access-key>"
aws_secret_key    = "<secret-key>"

# region, availability zones and subnets variables
aws_region          = "eu-west-2"
availability_zones  = [ "eu-west-2a", "eu-west-2b", "eu-west-2c" ]
vpc_cidr_block      = "10.0.0.0/16"
vpc_dns_support     = true
vpc_dns_hostnames   = true
public_subnets      = [ "10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24" ]
private_subnets     = [ "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24" ]

# tag variables
app_name            = "observer"
app_env             = "prod"

ecr_url             = "<account_id>.dkr.ecr.<region>.amazonaws.com/<repo_name>"