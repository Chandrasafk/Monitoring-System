#creating cloudwatch metric alarm: cpu utilization
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = var.cloudwatch_alarm_name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors ec2 cpu utilization"
  dimensions = {
    InstanceId = var.ec2_instance1_id
  }
  alarm_actions = [var.sns_topic_arn]
  tags = {
    Name = "ec2-cpu-high"
  }
}

#cloudWatch alarm: ec2 status check failed
resource "aws_cloudwatch_metric_alarm" "ec2_status_check_failed" {
  alarm_name          = var.cloudwatch_alarm_name2
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "Triggers when EC2 instance fails status check (system or instance)"
  treat_missing_data  = "missing"
  dimensions = {
    InstanceId = var.ec2_instance2_id
  }
  alarm_actions = [var.sns_topic_arn]
  tags = {
    Name = "ec2-status-check-failed"
  }
}

#creating cloudwatch dashboard
resource "aws_cloudwatch_dashboard" "cloudops_dashboard" {
  dashboard_name = var.cloudwatch_dashboard_name
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "EC2 Status Check Failed"
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          metrics = [
            ["AWS/EC2", "StatusCheckFailed", "InstanceId", var.ec2_instance2_id]
          ]
          period = 60
          stat   = "Maximum"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "EC2 CPU Utilization"
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", var.ec2_instance1_id]
          ]
          period = 120
          stat   = "Average"
          annotations = {
            horizontal = [
              {
                label = "Alarm Threshold"
                value = 80
              }
            ]
          }
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          title   = "Lambda Invocations"
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", var.log_delivery_function_name],
            ["AWS/Lambda", "Invocations", "FunctionName", var.log_analysis_function_name],
            ["AWS/Lambda", "Invocations", "FunctionName", var.remediation_function_name]
          ]
          period = 300
          stat   = "Sum"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          title   = "Lambda Errors"
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          metrics = [
            ["AWS/Lambda", "Errors", "FunctionName", var.log_delivery_function_name],
            ["AWS/Lambda", "Errors", "FunctionName", var.log_analysis_function_name],
            ["AWS/Lambda", "Errors", "FunctionName", var.remediation_function_name]
          ]
          period = 300
          stat   = "Sum"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6
        properties = {
          title   = "Lambda Duration"
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          metrics = [
            ["AWS/Lambda", "Duration", "FunctionName", var.log_delivery_function_name],
            ["AWS/Lambda", "Duration", "FunctionName", var.log_analysis_function_name],
            ["AWS/Lambda", "Duration", "FunctionName", var.remediation_function_name]
          ]
          period = 300
          stat   = "Average"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6
        properties = {
          title   = "SNS Published/Delivered/Failed Messages"
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          metrics = [
            ["AWS/SNS", "NumberOfMessagesPublished", "TopicName", var.sns_topic_name],
            ["AWS/SNS", "NumberOfNotificationsDelivered", "TopicName", var.sns_topic_name],
            ["AWS/SNS", "NumberOfNotificationsFailed", "TopicName", var.sns_topic_name]
          ]
          period = 300
          stat   = "Sum"
        }
      },
      {
        type   = "alarm"
        x      = 0
        y      = 18
        width  = 12
        height = 4
        properties = {
          title = "Active Alarms"
          alarms = [
            aws_cloudwatch_metric_alarm.ec2_cpu_high.arn,
            aws_cloudwatch_metric_alarm.ec2_status_check_failed.arn
          ]
        }
      },
      {
        type   = "log"
        x      = 12
        y      = 18
        width  = 12
        height = 6
        properties = {
          title  = "Recent EC2 Log Events"
          region = var.aws_region
          query  = "SOURCE '${var.log_group_name}' | fields @timestamp, @message | sort @timestamp desc | limit 20"
          view   = "table"
        }
      }
    ]
  })
}
