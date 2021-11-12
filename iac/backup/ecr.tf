# ecr.tf | Elastic Container Registry

resource "aws_ecr_repository" "ecr" {
  name = "${var.app_name}-ecr"

  tags = {
    Name        = "${var.app_name}-ecr"
    Environment = "${var.app_name}-${var.app_env}"
  }
}