variable "region" {
  type = string
}
variable "availability_zones" {
  type = list(any)
}
variable "vpc_name" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "public_subnet_ips" {
  type        = list(string)
  description = "List of public subnet IPs CIDR"
}
variable "private_subnet_ips" {
  type        = list(string)
  description = "List of private subnet IPs CIDR"
}

variable "workstation_ip" {
  type        = string
  description = "IP address of the workstation to allow access to bastion host"
}

variable "keypair_path" {
  type        = string
  description = "Path to the public key file for the key pair"
}

variable "bastion_instance_type" {
  type        = string
  description = "EC2 instance type used for bastion host"
}

variable "db_instance_type" {
  type        = string
  description = "EC2 instance type used for MongoDB instance"
}

variable "app_instance_type" {
  type        = string
  description = "EC2 instance type used for application instance"
}

variable "bastion_ami" {
  type = string
}

variable "db_ami" {
  type = string
}
variable "app_ami" {
  type = string
}
