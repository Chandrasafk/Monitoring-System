#mentioning the outputs
output "instance1_public_ip" {
  description = "Public IP of EC2 instance 1"
  value       = module.Compute.instance1_public_ip
}

output "instance2_public_ip" {
  description = "Public IP of EC2 instance 2"
  value       = module.Compute.instance2_public_ip
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket storing logs"
  value       = module.Storage.s3_bucket_name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = module.Messaging.sns_topic_arn
}

output "log_group_name" {
  description = "CloudWatch Log Group name"
  value       = module.Logging_pipeline.log_group_name
}

output "log_delivery_function_name" {
  description = "Name of the log delivery Lambda function"
  value       = module.Lambda_functions.log_delivery_function_name
}

output "log_analysis_function_name" {
  description = "Name of the log analysis Lambda function"
  value       = module.Lambda_functions.log_analysis_function_name
}

output "remediation_function_name" {
  description = "Name of the remediation Lambda function"
  value       = module.Lambda_functions.remediation_function_name
}
