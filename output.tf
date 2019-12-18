output "connect" {
  value = "ssh ec2-user@${length(aws_instance.bastion.public_ip) > 0 ? aws_instance.bastion.public_ip : aws_instance.bastion.private_ip}"
}

output "ec2_instance" {
  value = aws_instance.bastion
}

output "security_group" {
  value = aws_security_group.sg
}

output "key_pair" {
  value = aws_key_pair.key
}
