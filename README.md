# Resource Utilization Application

This project developed using the Python Flask for the backend and React-js for the front-end sides.

## Docker Compose

Run the applications as a container on the local Docker environment using docker-compose.

[Go to Docker-Compose example](iac/docker-compose#section)

## AWS Fargate - ECS

Run the applications as a container on the AWS Fargate serverless infrastructure using the Elastic Container Service and Elastic Container Registry.

### Create IAM requirements

Create a new IAM [User Role] with the following **Permission Policies** to manage ECS Fargate Cluster;

![AWS - ECS - Administrator User Role](assets/ecs-admin-user-role.png)

Create a new IAM [User] and add it to the newly created as "ecs-admin" group above to manage the ECS Fargate Cluster.

Get the Access and Secret Keys generated for this user to access AWS using Terraform and manage the ECS Cluster.

![AWS - ECS - Administrator User](assets/ecs-admin-user.png)

### Create ECR Private Registry

Create a new ECR Private Repository to push application Images

![ECR - Private Repository](assets/ecr-create-private-repo.png)


After the creation IAM requirements and ECR Private Repository go to the "iac/terraform-ecs" directory to create Elastic Container Service and other Service and Components using Terraform;

[Go to AWS - ECS Management example using Terraform](iac/terraform-ecs#section)
