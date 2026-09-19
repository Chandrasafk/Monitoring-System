variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "email" {
  description = "Email address for SNS notifications"
  type        = string
  default     = "giri.s.chandrashekar@gmail.com"
}