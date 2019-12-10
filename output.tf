output "connect" {
  value = "ssh ec2-user@${aws_instance.bastion.public_ip}"
}
