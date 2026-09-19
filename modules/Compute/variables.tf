variable "ec2_type" {
  description = "Type of EC2 instance to create"
  type        = string
  default     = "t3.micro"
}

variable "public_ip" {
  description = "Whether to assign a public IP address to the EC2 instance or not"
  type        = bool
  default     = true
}

variable "ec2_tags"{
  description = "Tags for EC2 instance"
  type        = string
  default     = "example1"
}

variable "ec2_tags2"{
  description = "Tags for EC2 instance"
  type        = string
  default     = "example2"
}

variable "public_subnet_id" {
  description = "ID of the subnet to launch the EC2 instance in"
  type        = string
}

variable "ec2_ami" {
  description = "AMI for ec2"
  type = string
  default = "ami-00d8aa800578d8b12"
}

variable "security_group_id" {
  type = string
  description = "Security group ID for the EC2 instance"
}

variable "iam_instance_profile" {
  type = string
  description = "IAM instance profile for the EC2 instance"
}

variable "log_group_name" {
  description = "CloudWatch log group name for the EC2 instances"
  type        = string
}

variable "key_name" {
  description = "Key pair name for the EC2 instance"
  type        = string
  default     = "cloudops-keypair"
}

variable "availability_zone" {
  description = "Availability zone for the EC2 instance"
  type        = string
  default     = "us-east-1a"
}