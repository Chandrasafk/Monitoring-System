variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "cloudops-security-group"
}

variable "security_group_tags" {
  description = "Tags for the security group"
  type        = string
  default     = "cloudops-security-group"
}

variable "vpc_id" {
  description = "VPC ID from Networking module"
  type        = string
}