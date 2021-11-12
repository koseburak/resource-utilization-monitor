# ecs.tf | Elastic Container Service Configuration

resource "aws_ecs_cluster" "ecs_cluster" {
    name = "${var.app_name}-${var.app_env}"
    
    tags = {
        Name        = "${var.app_name}-ecs_cluster"
  }
}

resource "aws_ecs_task_definition" "observer" {
  family                   = "${var.app_name}-${var.app_env}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = <<DEFINITION
  [
    {
      "name": "client",
      "image": "${var.ecr_url}:client-0.0.1",
      "entryPoint": [],
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.observer.id}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "cpu": 128,
      "memory": 512,
      "networkMode": "awsvpc"
    },
    {
      "name": "api",
      "image": "${var.ecr_url}:api-0.0.1",
      "entryPoint": [],
      "essential": false,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.observer.id}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "containerPort": 5000,
          "hostPort": 5000
        }
      ],
      "cpu": 64,
      "memory": 256,
      "networkMode": "awsvpc"
    },
    {
      "name": "nginx",
      "image": "${var.ecr_url}:nginx-0.0.1",
      "entryPoint": [],
      "essential": false,
      "dependsOn": [
        {
          "containerName": "client",
          "condition": "START"
        },
        {
          "containerName": "api",
          "condition": "START"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.observer.id}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "cpu": 64,
      "memory": 256,
      "networkMode": "awsvpc"
    }
  ]
  DEFINITION

  tags = {
    Name        = "${var.app_name}-ecs_td"
  }
}



resource "aws_ecs_service" "observer" {
  name                               = "${var.app_name}-service-${var.app_env}"
  cluster                            = aws_ecs_cluster.ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.observer.arn #"${aws_ecs_task_definition.client.family}:${max(aws_ecs_task_definition.client.revision, data.aws_ecs_task_definition.client.revision)}"
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  desired_count                      = 1
  force_new_deployment               = true
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
    security_groups = [ aws_security_group.ecs_tasks.id ]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.observer.arn
    container_name   = "nginx"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

  depends_on = [aws_alb_listener.http]
}