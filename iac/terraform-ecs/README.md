# IaC - Terraform - AWS / ECS

Create the Infrastructure on the AWS using Terraform

## Create and Manage AWS Fargate ECS using Terraform

Go to the "iac/terraform-ecs" directory with the following command and after please run the next commands in this directory;
```local
cd iac/terraform-ecs
````

Note: Enter your own variable values in the **"iac/terraform-ecs/terraform.tfvars"** file

<br/>

## Download and Install Terraform
You could download and install the Terraform from the [downloads page](https://www.terraform.io/downloads.html).

<br/>

## Run Terraform and Create Infrastructure

If you have [Terraform](https://www.terraform.io/) installed, create your infrastructure with the following below commands;

1. Run the below command in a terminal, to initialize the provider plugins:
    ```console
    terraform init
    ```

2. Run the below command in a terminal, to check your configuration is valid:
    ```console
    terraform validate
    ```

3. Run the below command in a terminal to create an execution plan;
    ```console
    terraform plan -out=observer-tfplan
    ```
4. Run the below command in a terminal to show human-readable output from plan file:
    ```console
    terraform show observer-tfplan
    ```

5. Run the below command in a terminal, to Create or Update infrastructure on the AWS:
    ```console
    terraform apply -auto-approve "observer-tfplan"
    ```

6. Run the below command in a terminal, to Destroy previously-created infrastructure on the AWS:

    ```console
    terraform destroy
    ```