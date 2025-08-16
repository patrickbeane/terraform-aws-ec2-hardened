output "instance_public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.example_instance.public_ip
}

output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.example_instance.id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.example_aws_sg.id
}

output "ssh_command" {
  description = "Convenient SSH command"
  value       = format("ssh -p %d ubuntu@%s", var.ssh_port, aws_instance.example_instance.public_ip)
}

output "portainer_url" {
  description = "Portainer URL (if enabled and allowed by CIDR)"
  value       = format("https://%s:%d", aws_instance.example_instance.public_ip, var.portainer_port)
}
