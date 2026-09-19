#archive each lambda's source file
data "archive_file" "log_delivery_zip" {
  type        = "zip"
  source_file = "${path.module}/log_delivery.py"
  output_path = "${path.module}/log_delivery.zip"
}
data "archive_file" "log_analysis_zip" {
  type        = "zip"
  source_file = "${path.module}/log_analysis.py"
  output_path = "${path.module}/log_analysis.zip"
}
data "archive_file" "remediation_zip" {
  type        = "zip"
  source_file = "${path.module}/remediation.py"
  output_path = "${path.module}/remediation.zip"
}

#creating lambda functions
resource "aws_lambda_function" "log_delivery" {
  function_name    = var.log_delivery_function_name
  role             = var.lambda_role_arn
  handler          = "log_delivery.handler"
  runtime          = var.lambda_runtime
  filename         = data.archive_file.log_delivery_zip.output_path
  source_code_hash = data.archive_file.log_delivery_zip.output_base64sha256
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory_size
  environment {
    variables = {
      BUCKET_NAME = var.s3_bucket_id
    }
  }
  tags = {
    Name = var.log_delivery_function_name
  }
}
resource "aws_lambda_function" "log_analysis" {
  function_name    = var.log_analysis_function_name
  role             = var.lambda_role_arn
  handler          = "log_analysis.handler"
  runtime          = var.lambda_runtime
  filename         = data.archive_file.log_analysis_zip.output_path
  source_code_hash = data.archive_file.log_analysis_zip.output_base64sha256
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory_size
  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
  tags = {
    Name = var.log_analysis_function_name
  }
}
resource "aws_lambda_function" "remediation" {
  function_name    = var.remediation_function_name
  role             = var.lambda_role_arn
  handler          = "remediation.handler"
  runtime          = var.lambda_runtime
  filename         = data.archive_file.remediation_zip.output_path
  source_code_hash = data.archive_file.remediation_zip.output_base64sha256
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory_size
  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
  tags = {
    Name = var.remediation_function_name
  }
}

#lambda permission for cloudwatch log group to invoke log_delivery lambda function
resource "aws_lambda_permission" "allow_cloudwatch_invoke_log_delivery" {
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.log_delivery.function_name
  principal     = "logs.amazonaws.com"
  source_arn    = "${var.log_group_arn}:*"
}

#creating cloudwatch log subscription filter to send logs to log_delivery lambda function
resource "aws_cloudwatch_log_subscription_filter" "log_delivery_subscription" {
  name            = "log-delivery-subscription"
  log_group_name  = var.log_group_name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.log_delivery.arn

  depends_on = [aws_lambda_permission.allow_cloudwatch_invoke_log_delivery]
}

#lambda permission for s3 bucket to invoke log_analysis lambda function
resource "aws_lambda_permission" "allow_s3_invoke_log_analysis" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.log_analysis.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}

#creating s3 bucket notification to trigger log_analysis lambda function on new log files
resource "aws_s3_bucket_notification" "log_analysis_trigger" {
  bucket = var.s3_bucket_id
  lambda_function {
    lambda_function_arn = aws_lambda_function.log_analysis.arn
    events              = ["s3:ObjectCreated:Put"]
    filter_prefix       = "logs/"
  }
  depends_on = [aws_lambda_permission.allow_s3_invoke_log_analysis]
}

#lambda permission for sns topic to invoke remediation lambda function
resource "aws_lambda_permission" "allow_sns_invoke_remediation" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.remediation.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}

#creating sns topic subscription to trigger remediation lambda function on new messages
resource "aws_sns_topic_subscription" "remediation_subscription" {
  topic_arn = var.sns_topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.remediation.arn
  depends_on = [aws_lambda_permission.allow_sns_invoke_remediation]
}