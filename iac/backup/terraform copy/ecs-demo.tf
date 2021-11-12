data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

data "aws_ecs_task_definition" "demo" {
  task_definition = aws_ecs_task_definition.demo.family
}

resource "aws_ecs_task_definition" "demo" {
  family = "${var.app_name}-demo"

  container_definitions = <<DEFINITION
  [
    {
      "name": "demo",
      "image": "${var.ecr_url}:dotnet",
      "entryPoint": [],
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.log_group.id}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "demo"
        }
      },
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc"
    }
  ]
  DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  tags = {
    Name        = "${var.app_name}-ecs_td-demo"
    Environment = "${var.app_name}-${var.app_env}"
  }
}


resource "aws_ecs_service" "demo" {
  name                 = "demo"
  cluster              = aws_ecs_cluster.ecs_cluster.id
  task_definition      = "${aws_ecs_task_definition.demo.family}:${max(aws_ecs_task_definition.demo.revision, data.aws_ecs_task_definition.demo.revision)}"
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = aws_subnet.public.*.id
    assign_public_ip = false
    security_groups = [
      aws_security_group.service_security_group.id,
      aws_security_group.load_balancer_security_group.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "demo"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.listener_http]
}