// define variables
variable "region" {
  description = "The region where the EC2 instance will be created"
  type        = string
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
