module "bastion" {
  #source            = "git@github.com:byu-oit/terraform-aws-bastion.git?ref=v1.0.0"
  source            = "git@github.com:byu-oit/terraform-aws-bastion.git"
  env               = "prd"
  vpc_vpn_to_campus = true
  netid             = "mynetid"
  public_key        = "ssh-rsa AA...[redacted]...Qw== comment"
}
