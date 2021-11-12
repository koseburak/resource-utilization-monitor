data "aws_ecs_task_definition" "client" {
  task_definition = aws_ecs_task_definition.client.family
}

resource "aws_ecs_task_definition" "client" {
  family = "${var.app_name}-client"

  container_definitions = <<DEFINITION
  [
    {
      "name": "client",
      "image": "funf/observer:client-0.0.1",
      "entryPoint": [],
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.log_group.id}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "client"
        }
      },
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
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
    Name        = "${var.app_name}-ecs_td-client"
    Environment = "${var.app_name}-${var.app_env}"
  }
}


resource "aws_ecs_service" "client" {
  name                 = "client"
  cluster              = aws_ecs_cluster.ecs_cluster.id
  task_definition      = "${aws_ecs_task_definition.client.family}:${max(aws_ecs_task_definition.client.revision, data.aws_ecs_task_definition.client.revision)}"
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
    container_name   = "client"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.listener_http]
}