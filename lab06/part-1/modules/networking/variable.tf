variable "region" {
  type        = string
  description = "The AWS region where resources will be created"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "public_subnet_ips" {
  type        = list(string)
  description = "A list of CIDR blocks for the public subnets"
}

variable "private_subnet_ips" {
  type        = list(string)
  description = "A list of CIDR blocks for the private subnets"
}

variable "availability_zones_1" {
  type        = string
  description = "The availability zone for the first public subnet"
}

variable "availability_zones_2" {
  type        = string
  description = "The availability zone for the second public subnet"
}
