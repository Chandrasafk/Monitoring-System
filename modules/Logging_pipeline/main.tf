#creating cloudwatch log group
resource "aws_cloudwatch_log_group" "ec2_logs" {
  name = var.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_log_group_retention
  tags = {
    Environment = "prod"
  }
}