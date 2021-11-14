# alb.tf | Load Balancer Configuration

resource "aws_alb" "observer" {
  name               = "${var.app_name}-${var.app_env}-observer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public.*.id

  enable_deletion_protection = false

  tags = {
    Name        = "${var.app_name}-alb"
  }
}

resource "aws_alb_target_group" "observer" {
  name        = "${var.app_name}-${var.app_env}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.observer.id

  health_check {
    healthy_threshold   = "3"
    interval            = "60"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.app_name}-tg"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.observer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.observer.id
  }

}




# # Redirect to https listener
# resource "aws_alb_listener" "http" {
#   load_balancer_arn = aws_lb.observer.id
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = 443
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

# # Redirect traffic to target group
# resource "aws_alb_listener" "https" {
#     load_balancer_arn = aws_lb.observer.id
#     port              = 443
#     protocol          = "HTTPS"

#     ssl_policy        = "ELBSecurityPolicy-2016-08"
#     certificate_arn   = var.alb_tls_cert_arn

#     default_action {
#         target_group_arn = aws_alb_target_group.observer.id
#         type             = "forward"
#     }
# }

# output "aws_alb_target_group_arn" {
#   value = aws_alb_target_group.observer.arn
# }
