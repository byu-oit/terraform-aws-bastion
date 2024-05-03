terraform {
  required_version = "1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

module "bastion" {
  source            = "../../"
  env               = "dev"
  vpc_vpn_to_campus = false
  netid             = "githubac"
  public_key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwWVPlHpRiXGBmB/VG6PUeJ/Ev+Y39n5PBI4DW3ZMDT1g32nEUjzKtxK6KwVzYFQBhReMO2ry4uSTiNIzuOtHk/OCfcdPc8wbW3RlHBgbqs6p7DfYRJAXJCnWEjovijaVY0lyL4+7/YuprZwBaA2NfUIRN8UwVxZck3ULMnCK6BKog0UAE9NQZ9Z0vAtgLYPo9eVJEuGrxEszN29X+4Fl6u3T8x0XQ9EoMWU4YNwKfzBIof3th9Cbv4+FlEKpOFYuCc5vB2NPotalN8phEUqnvtsDkmCLAop6+MrUlnNNYIzmh2RLeqDF+M/ZnX8xb+V/mT9vARVcdcYCxKYeyXLvT example"
}

output "connect" {
  value = module.bastion.connect
}

output "ec2_instance" {
  value = module.bastion.ec2_instance
}

output "security_group" {
  value = module.bastion.security_group
}

output "key_pair" {
  value = module.bastion.key_pair
}
