provider "aws" {
  version = "~> 2.42"
  region  = "us-west-2"
}

module "bastion" {
  #source            = "../../"
  source            = "github.com/byu-oit/terraform-aws-bastion.git?ref=v1.2.1"
  env               = "dev"
  vpc_vpn_to_campus = false
  netid             = "jgubler"
  public_key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwWVPlHpRiXGBmB/VG6PUeJ/Ev+Y39n5PBI4DW3ZMDT1g32nEUjzKtxK6KwVzYFQBhReMO2ry4uSTiNIzuOtHk/OCfcdPc8wbW3RlHBgbqs6p7DfYRJAXJCnWEjovijaVY0lyL4+7/YuprZwBaA2NfUIRN8UwVxZck3ULMnCK6BKog0UAE9NQZ9Z0vAtgLYPo9eVJEuGrxEszN29X+4Fl6u3T8x0XQ9EoMWU4YNwKfzBIof3th9Cbv4+FlEKpOFYuCc5vB2NPotalN8phEUqnvtsDkmCLAop6+MrUlnNNYIzmh2RLeqDF+M/ZnX8xb+V/mT9vARVcdcYCxKYeyXLvT example"
  #ingress_cidrs     = ["128.187.112.21/32"] # optional (defaults to BYU Campus)
  #subnet_type       = "private" # optional (defaults to public) (if anything other than "public", you'll need to use another bastion, vpn, etc. to ssh in.)
}

output "connect" {
  value = module.bastion.connect
}
