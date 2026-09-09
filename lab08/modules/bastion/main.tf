resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  root_block_device {
    volume_size = 10
    encrypted   = true
  }

  tags = {
    Name = "Bastion"
  }
}
