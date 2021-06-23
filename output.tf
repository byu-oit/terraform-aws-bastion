output "connect" {
  value = "ssh ec2-user@${aws_route53_record.a_record.name}"
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

output "route53_record" {
  value = aws_route53_record.a_record
}
