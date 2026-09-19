variable "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
  default     = "/ec2/bucketname/logs"
}

variable "cloudwatch_log_group_retention" {
  description = "Retention period for the CloudWatch log group in days"
  type        = number
  default     = 30
}