# IaC - Terraform - AWS

## Install Terraform
Visit the; https://www.terraform.io/downloads.html


aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 089019333320.dkr.ecr.eu-west-2.amazonaws.com

export AWS_REPO="089019333320.dkr.ecr.eu-west-2.amazonaws.com/observer-ecr"



docker tag funf/observer:nginx-0.0.1 $AWS_REPO:nginx-0.0.1

docker push $AWS_REPO:nginx-0.0.1


docker tag funf/observer:client-0.0.1 $AWS_REPO:client-0.0.1

docker push $AWS_REPO:client-0.0.1


docker tag funf/observer:api-0.0.1 $AWS_REPO:api-0.0.1

docker push $AWS_REPO:api-0.0.1

##################################################################

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 089019333320.dkr.ecr.eu-west-2.amazonaws.com

docker tag observer:latest 089019333320.dkr.ecr.eu-west-2.amazonaws.com/observer:dotnet