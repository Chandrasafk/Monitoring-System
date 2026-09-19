output "sns_topic_arn" {
  value = aws_sns_topic.cloudops_alerts.arn
}

output "sns_topic_name" {
  value = aws_sns_topic.cloudops_alerts.name
}