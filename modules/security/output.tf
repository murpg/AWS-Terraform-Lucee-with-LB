output "sg_alb" {
  value = aws_security_group.alb.id
}

output "sg_ec2" {
  value = aws_security_group.ec2.id
}

output "sg_nlb" {
  value = aws_security_group.nlb.id
}

output "ssh_key_name" {
  value = aws_key_pair.ssh.key_name
}

output "ssh_private_key" {
  value     = tls_private_key.key.private_key_openssh
  sensitive = true
}
