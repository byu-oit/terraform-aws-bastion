provider "aws" {
  version = "~> 3.0"
  region  = "us-west-2"
}

locals {
  env                  = "dev"
  netid                = "jgubler"
  public_key           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwWVPlHpRiXGBmB/VG6PUeJ/Ev+Y39n5PBI4DW3ZMDT1g32nEUjzKtxK6KwVzYFQBhReMO2ry4uSTiNIzuOtHk/OCfcdPc8wbW3RlHBgbqs6p7DfYRJAXJCnWEjovijaVY0lyL4+7/YuprZwBaA2NfUIRN8UwVxZck3ULMnCK6BKog0UAE9NQZ9Z0vAtgLYPo9eVJEuGrxEszN29X+4Fl6u3T8x0XQ9EoMWU4YNwKfzBIof3th9Cbv4+FlEKpOFYuCc5vB2NPotalN8phEUqnvtsDkmCLAop6+MrUlnNNYIzmh2RLeqDF+M/ZnX8xb+V/mT9vARVcdcYCxKYeyXLvT example"
  private_key_filename = "~/.ssh/id_rsa"
  my_public_ip         = "128.187.112.21"
}

module "public_bastion" {
  source            = "github.com/byu-oit/terraform-aws-bastion.git?ref=v2.0.0"
  env               = local.env
  vpc_vpn_to_campus = true
  netid             = "${local.netid}-public"
  public_key        = local.public_key
  ingress_cidrs     = ["${local.my_public_ip}/32"]
  subnet_type       = "public"
}


module "private_bastion" {
  source            = "git@github.com:byu-oit/terraform-aws-bastion.git?ref=v2.0.0"
  env               = local.env
  vpc_vpn_to_campus = true
  netid             = "${local.netid}-private"
  public_key        = local.public_key
  ingress_cidrs     = ["${module.public_bastion.ec2_instance.private_ip}/32"]
  subnet_type       = "private"
}

output "ssh_config" {
  value = <<EOF
Host public-bastion
  User=ec2-user
  HostName=${module.public_bastion.ec2_instance.public_ip}
  Port=22
  IdentityFile=${local.private_key_filename}
Host private-bastion
  User=ec2-user
  HostName=${module.private_bastion.ec2_instance.private_ip}
  Port=22
  ProxyJump=public-bastion
  IdentityFile=${local.private_key_filename}
EOF
}

output "instructions" {
  value = <<EOF
1. terrafrom output ssh_config >> ~/.ssh/config
2. ssh private-bastion
3. test connection back to campus (ping, telnet, mysql, ssh, etc.)
EOF
}
