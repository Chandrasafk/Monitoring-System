variable "ec2_instance1_id" {
  description = "ID of the EC2 instance to monitor for status check failures"
  type        = string
}

variable "ec2_instance2_id" {
  description = "ID of the EC2 instance to monitor for CPU utilization"
  type        = string
}

variable "aws_region" {
  description = "AWS region for dashboard widget metrics"
  type        = string
  default     = "us-east-1"
}

variable "cloudwatch_alarm_name" {
  description = "Name of the CloudWatch alarm for CPU utilization"
  type        = string
  default     = "ec2-cpu-high"
}

variable "cloudwatch_alarm_name2" {
  description = "Name of the CloudWatch alarm for status check failures"
  type        = string
  default     = "ec2-status-check-failed"
}

variable "cloudwatch_dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  type        = string
  default     = "cloudops-dashboard"
}

variable "sns_topic_arn" {
  type = string
  description = "ARN of the SNS topic for alarm notifications"
}

variable "log_group_name" {
  type = string
  description = "Name of the CloudWatch log group for Lambda function logs"
}

variable "log_delivery_function_name" {
  type = string
  description = "Name of the Lambda function for log delivery"
}

variable "log_analysis_function_name" {
  type = string
  description = "Name of the Lambda function for log analysis"
}

variable "remediation_function_name" {
  type = string
  description = "Name of the Lambda function for remediation"
}

variable "sns_topic_name" {
  type = string
  description = "Name of the SNS topic for remediation notifications"
}