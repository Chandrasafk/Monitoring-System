variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "vpc_tags" {
  description = "Tags for the VPC"
  type        = string
  default     = "myvpc"
}

variable "public_subnet_tags" {
  description = "Tags for the public subnet"
  type        = string
  default     = "public-subnet"
}

variable "internet_gateway_tags" {
  description = "Tags for the internet gateway"
  type        = string
  default     = "gw"
}

variable "route_table_tags" {
  description = "Tags for the route table"
  type        = string
  default     = "routetable"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet"
  type        = string
  default     = "us-east-1a"
}