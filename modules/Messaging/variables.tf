variable "sns_topic_name" {
  description = "The name of the SNS topic"
  type        = string
  default     = "cloudops-alerts"
}

variable "email_endpoint" {
  description = "The email address to receive notifications"
  type        = string
  default     = "giri.s.chandrashekar@gmail.com"
}