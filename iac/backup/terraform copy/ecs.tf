# ecs.tf | Elastic Container Service Configuration

resource "aws_ecs_cluster" "ecs_cluster" {
    name = "${var.app_name}-${var.app_env}-cluster"
    
    tags = {
        Name        = "${var.app_name}-ecs"
        Environment = "${var.app_name}-${var.app_env}"
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.app_name}-${var.app_env}-log_group"

    tags = {
        Name        = "${var.app_name}-log_group"
        Environment = "${var.app_name}-${var.app_env}"
  }
}

# aws_ecs_task_definition.ecs_task_definiton

# aws_ecs_task_definition.main

# aws_ecs_service.ecs_service

resource "aws_security_group" "service_security_group" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.app_name}-ecs_service_sg"
    Environment = "${var.app_name}-${var.app_env}"
  }
}