output "instance_public_ip" {
  description = "Public IP of the Jenkins instance"
  value       = module.compute.public_ip
}

output "ssh_command" {
  description = "Command to SSH into the Jenkins instance"
  value       = "ssh -i <path-to-private-key> ubuntu@${module.compute.public_ip}"
}
