variable "region_name" {
  type = string
}

variable "image_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "volume_size" {
  type = number
}

variable "myIp" {
  description = "Your public IP address"
  type        = string
}
