# IaC - Terraform - AWS / ECS

## Install Terraform
Visit the https://www.terraform.io/downloads.html

## Create and Manage AWS Fargate ECS using Terraform

Go to terraform-ecs directory with the following command and after please run the next commands in this directory;
```local
cd iac/terraform-ecs
````

Take the access Token for **ECR Private Repository** using the **aws-cli**;
```local
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account_id>.dkr.ecr.<region>.amazonaws.com
```

Set the ECR Repository address as a ENV value;
```local
export ECR_REPO="<account_id>.dkr.ecr.<region>.amazonaws.com/<repo_name>"
```
<br/>

Build and Push the Image to ECR Private Repository for Python Restapi application;
```local
docker build -f api/Dockerfile -t $ECR_REPO:api-0.0.1 .
docker push $ECR_REPO:api-0.0.1
```
<br/>

Build and Push the Image to ECR Private Repository for React front-end application;
```local
docker build -f sys-stats/Dockerfile -t $ECR_REPO:client-0.0.1 .
docker push $ECR_REPO:client-0.0.1
```
<br/>

Build and Push the Image to ECR Private Repository for Nginx proxy server;
```local
docker build --build-arg NGINX_CONF=aws-ecs -t $ECR_REPO:nginx-0.0.1
docker push $ECR_REPO:nginx-0.0.1
```