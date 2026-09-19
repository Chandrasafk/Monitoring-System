output "log_group_arn" {
  value = aws_cloudwatch_log_group.ec2_logs.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ec2_logs.name
}