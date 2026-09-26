resource "aws_instance" "udemy-instance" {
  ami           = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name
  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name = "udemy-instance"
  }
  vpc_security_group_ids = var.security_group_ids
}
