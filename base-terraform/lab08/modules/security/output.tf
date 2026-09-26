output "application_sg_id" {
  value = aws_security_group.application.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "mongo_sg_id" {
  value = aws_security_group.mongodb.id
}
