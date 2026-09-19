resource "aws_sns_topic" "cloudops_alerts" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.cloudops_alerts.arn
  protocol  = "email"
  endpoint  = var.email_endpoint

  lifecycle {
    ignore_changes = [
      endpoint,
      topic_arn,
    ]
  }
}