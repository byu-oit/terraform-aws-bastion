provider "aws" {
  version = "~> 2.42"
  region  = "us-west-2"
}

module "bastion" {
  #source            = "../../"
  source            = "github.com/byu-oit/terraform-aws-bastion.git?ref=v1.3.0"
  env               = "dev"
  vpc_vpn_to_campus = false
  netid             = "jgubler"
  public_key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwWVPlHpRiXGBmB/VG6PUeJ/Ev+Y39n5PBI4DW3ZMDT1g32nEUjzKtxK6KwVzYFQBhReMO2ry4uSTiNIzuOtHk/OCfcdPc8wbW3RlHBgbqs6p7DfYRJAXJCnWEjovijaVY0lyL4+7/YuprZwBaA2NfUIRN8UwVxZck3ULMnCK6BKog0UAE9NQZ9Z0vAtgLYPo9eVJEuGrxEszN29X+4Fl6u3T8x0XQ9EoMWU4YNwKfzBIof3th9Cbv4+FlEKpOFYuCc5vB2NPotalN8phEUqnvtsDkmCLAop6+MrUlnNNYIzmh2RLeqDF+M/ZnX8xb+V/mT9vARVcdcYCxKYeyXLvT example"
  #ingress_cidrs     = ["128.187.112.21/32"] # optional (defaults to BYU Campus)
  #subnet_type       = "private" # optional (defaults to public) (if anything other than "public", you'll need to use another bastion, vpn, etc. to ssh in.)
}

# When you use a bastion, you almost always need to add a
# security group rule to allow that bastion to connect to
# another resource (RDS, EC2, EFS, etc.). You can do that in
# Terraform, with an aws_security_group_rule resource.
/*
resource "aws_security_group_rule" "bastion_to_rds" {
  type                     = "ingress"
  source_security_group_id = module.bastion.security_group.id

  # Different services (mysql, postgress, SSH, EFS, etc) have
  # different ports. Specify the correct ports here.
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"

  # You'll need to login to the console and lookup the
  # Security Group ID for the target resource that your
  # bastion is going to connect to.
  security_group_id        = "sg_xxxxxxxxxxxxxx"
}

output "tunnel_connect" {
  # You'll need to login to the console and lookup the
  # Endpoint Address of your RDS instance. If you are
  # targeting something other than mysql on RDS, update the
  # host and ports to match your target resource.
  #
  # Learn more about SSH Tunneling: https://www.ssh.com/ssh/tunneling/example
  value = "ssh -L 3306:my_rds_instance_address:3306 ec2-user@${module.bastion.ec2_instance.public_ip}"
}
*/

output "connect" {
  value = module.bastion.connect
}
