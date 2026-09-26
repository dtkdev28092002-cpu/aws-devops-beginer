// define variables
variable "image_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
}

variable "region" {
  description = "The region where the EC2 instance will be created"
  type        = string
  default     = "ap-southeast-1"
}
variable "amis" {
  type = map(any)
  default = {
    "ap-southeast-1" = "ami-02159ad7e38d562f2"
    "ap-northeast-1" = "ami-0532913178263be11"
  }
}

variable "keypair_path" {
  type    = string
  default = "./keypair/udemy-key.pub"
}
