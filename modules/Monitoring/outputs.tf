output "cpu_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.ec2_cpu_high.arn
}

output "status_check_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.ec2_status_check_failed.arn
}