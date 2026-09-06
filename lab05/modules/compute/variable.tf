variable "region" {
  type = string
}

variable "image_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instance"
  type        = string
  nullable    = false
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
}

variable "ec2_security_group_ids" {
  description = "List of security group IDs to associate with the EC2 instance"
  type        = list(string)
  nullable    = false
}
