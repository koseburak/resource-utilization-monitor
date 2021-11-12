data "aws_ecs_task_definition" "api" {
  task_definition = aws_ecs_task_definition.api.family
}

resource "aws_ecs_task_definition" "api" {
  family = "${var.app_name}-api"

  container_definitions = <<DEFINITION
  [
    {
      "name": "api",
      "image": "funf/observer:api-0.0.1",
      "entryPoint": [],
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.log_group.id}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "api"
        }
      },
      "portMappings": [
        {
          "containerPort": 5000,
          "hostPort": 5000
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
    Name        = "${var.app_name}-ecs_td-api"
    Environment = "${var.app_name}-${var.app_env}"
  }
}


resource "aws_ecs_service" "api" {
  name                 = "api"
  cluster              = aws_ecs_cluster.ecs_cluster.id
  task_definition      = "${aws_ecs_task_definition.api.family}:${max(aws_ecs_task_definition.api.revision, data.aws_ecs_task_definition.api.revision)}"
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
    security_groups = [
      aws_security_group.service_security_group.id,
      aws_security_group.load_balancer_security_group.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "api"
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.listener_http]
}