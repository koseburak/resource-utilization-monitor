# log.tf | VPC Log Configuration

resource "aws_cloudwatch_log_group" "observer" {
  name = "/ecs/${var.app_name}-${var.app_env}"

    tags = {
        Name        = "${var.app_name}-log_group"
  }
}

resource "aws_flow_log" "observer" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.observer.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.observer.id
}
