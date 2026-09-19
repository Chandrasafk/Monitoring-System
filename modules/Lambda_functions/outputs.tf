output "log_delivery_function_arn" {
  value = aws_lambda_function.log_delivery.arn
}

output "log_analysis_function_arn" {
  value = aws_lambda_function.log_analysis.arn
}

output "remediation_function_arn" {
  value = aws_lambda_function.remediation.arn
}

output "log_delivery_function_name" {
  value = aws_lambda_function.log_delivery.function_name
}

output "log_analysis_function_name" {
  value = aws_lambda_function.log_analysis.function_name
}

output "remediation_function_name" {
  value = aws_lambda_function.remediation.function_name
}