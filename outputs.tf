output "bastion_public_ip" {
  description = "The public IP address of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_sg_id" {
  description = "The ID of the Security Group for the Bastion Host"
  value       = aws_security_group.sg_bastion.id
}

output "bastion_public_dns" {
  description = "The public DNS name of the Bastion Host"
  value       = aws_instance.bastion.public_dns
}