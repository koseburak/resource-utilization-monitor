# iam.tf | IAM Role Policies

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name   = "${var.app_name}-${var.app_env}-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy_attachment" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



# resource "aws_iam_policy" "secrets" {
#   name   = "${var.app_name}-taskPolicySecrets"
#   description = "Policy that allows access to the secrets we created"

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "AccessSecrets",
#             "Effect": "Allow",
#             "Action": [
#               "secretsmanager:GetSecretValue"
#             ],
#             "Resource": ${jsonencode(var.container_secrets_arns)}
#         }
#     ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy_attachment_for_secrets" {
#   role       = aws_iam_role.ecsTaskExecutionRole.name
#   policy_arn = aws_iam_policy.secrets.arn
# }














resource "aws_iam_role" "vpc_flow_logs_role" {
  name   = "${var.app_name}-${var.app_env}-vpc_flow_logs_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name   = "${var.app_name}-${var.app_env}-vpc_flow_logs_policy"
  role = aws_iam_role.vpc_flow_logs_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}