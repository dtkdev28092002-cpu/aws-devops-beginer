provider "aws" {
  region = var.region
}

resource "aws_instance" "udemy-instance" {
  ami           = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  tags = {
    Name = "udemy-instance"
  }
  vpc_security_group_ids = var.ec2_security_group_ids
}

resource "aws_eip" "udemy-eip" {
  instance = aws_instance.udemy-instance.id
}
