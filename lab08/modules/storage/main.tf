resource "aws_instance" "mongo" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  root_block_device {
    volume_size = 10
    encrypted   = true
  }
  user_data_base64 = filebase64("${path.module}/install.sh")

  tags = {
    Name = "MongoDB"
  }
}
