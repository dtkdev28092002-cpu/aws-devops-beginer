output "instance_ip_addr_public" {
  value = aws_eip.udemy-eip.public_ip
}

output "instance_ip_addr_private" {
  value = aws_instance.udemy-instance.private_ip
}
