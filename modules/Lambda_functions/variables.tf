variable "log_delivery_function_name" {
  description = "Name of the log delivery Lambda function"
  type        = string
  default     = "cloudops-log-delivery"
}

variable "log_analysis_function_name" {
  description = "Name of the log analysis Lambda function"
  type        = string
  default     = "cloudops-log-analysis"
}

variable "remediation_function_name" {
  description = "Name of the remediation Lambda function"
  type        = string
  default     = "cloudops-remediation"
}

variable "lambda_runtime" {
  description = "Runtime for all Lambda functions"
  type        = string
  default     = "python3.12"
}

variable "lambda_timeout" {
  description = "Timeout in seconds for all Lambda functions"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Memory size in MB for all Lambda functions"
  type        = number
  default     = 128
}

variable "lambda_role_arn" {
  description = "IAM role ARN for Lambda functions"
  type        = string
}

variable "log_group_arn" {
  type = string
  description = "ARN of the CloudWatch Log Group to which the log_delivery Lambda function will be subscribed"
}

variable "log_group_name" {
  type = string
  description = "Name of the CloudWatch Log Group to which the log_delivery Lambda function will be subscribed"
}

variable "s3_bucket_arn" {
  type = string
  description = "ARN of the S3 bucket where logs will be stored"
}

variable "s3_bucket_id" {
  type = string
  description = "ID of the S3 bucket where logs will be stored"
}

variable "sns_topic_arn" {
  type = string
  description = "ARN of the SNS topic that will trigger the remediation Lambda function"
}