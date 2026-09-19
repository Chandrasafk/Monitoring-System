#create a security group
resource "aws_security_group" "allow_tls" {
  name        = var.security_group_name
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id
  tags = {
    Name = var.security_group_tags
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3389
  ip_protocol       = "tcp"
  to_port           = 3389
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#iam role for ec2 instance
resource "aws_iam_role" "iamforec2" {
  name = "iamforec2"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Name = "iamforec2"
  }
}
#policy attachment is CloudWatchFullAccess
resource "aws_iam_role_policy_attachment" "cloudwatch_full_access" {
  role       = aws_iam_role.iamforec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}
#policy attachment is AmazonSSMManagedInstanceCore
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.iamforec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
#iam instance profile for ec2
resource "aws_iam_instance_profile" "iamforec2_profile" {
  name = "iamforec2-instance-profile"
  role = aws_iam_role.iamforec2.name
}

#iam role for lambda
resource "aws_iam_role" "iamforlambda" {
  name = "iamforlambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Name = "iamforlambda"
  }
}
#policy attachment is AWSLambdaBasicExecutionRole
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.iamforlambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
#policy attachment is AmazonS3FullAccess
resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.iamforlambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
#policy attachment is AmazonSNSFullAccess
resource "aws_iam_role_policy_attachment" "sns_full_access" {
  role       = aws_iam_role.iamforlambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}
#policy attachment is AmazonEC2FullAccess
resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.iamforlambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
