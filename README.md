![Latest GitHub Release](https://img.shields.io/github/v/release/byu-oit/terraform-aws-bastion?sort=semver)

# terraform-aws-bastion

Create a temporary bastion in an AWS Account

**Note**

> This module automatically looks up the latest AMI each time `terraform
> apply` is run. This could result in your bastion EC2 instance being
> replaced. This shouldn't be a problem. The bastion is intended to be
> short lived. If this is an issue for you, you probably aren't using
> the bastion the way it is intended to be used.

## Usage

In a clean directory, create a `main.tf` file that looks like:

```hcl
provider "aws" {
  version = "~> 3.0"
  region  = "us-west-2"
}

module "bastion" {
  source            = "github.com/byu-oit/terraform-aws-bastion.git?ref=v2.1.0"
  env               = "prd"
  vpc_vpn_to_campus = true
  netid             = "mynetid"
  public_key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwWVPlHpRiXGBmB/VG6PUeJ/Ev+Y39n5PBI4DW3ZMDT1g32nEUjzKtxK6KwVzYFQBhReMO2ry4uSTiNIzuOtHk/OCfcdPc8wbW3RlHBgbqs6p7DfYRJAXJCnWEjovijaVY0lyL4+7/YuprZwBaA2NfUIRN8UwVxZck3ULMnCK6BKog0UAE9NQZ9Z0vAtgLYPo9eVJEuGrxEszN29X+4Fl6u3T8x0XQ9EoMWU4YNwKfzBIof3th9Cbv4+FlEKpOFYuCc5vB2NPotalN8phEUqnvtsDkmCLAop6+MrUlnNNYIzmh2RLeqDF+M/ZnX8xb+V/mT9vARVcdcYCxKYeyXLvT example"
  #ingress_cidrs     = ["128.187.112.21/32"] # optional (defaults to BYU Campus)
  #subnet_type       = private # optional (defaults to public)
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
```

You need to update the variable values. (i.e. use your netid, your
public ssh key, etc.)

Then run:

```shell
terraform init
terraform apply
```

When you're done, run:

```shell
terraform destroy
```

## Backend

The bastion is really intended to be ephemeral (spin it up, use it, tear
it down). So there's no need for a backend.

## Input

| Name              | Type         | Description                                                                     | Default Value                                          |
|:------------------|:-------------|:--------------------------------------------------------------------------------|:-------------------------------------------------------|
| env               | string       | Environment (for tagging the bastion) (e.g. dev, prd)                           |                                                        |
| vpc_vpn_to_campus | bool         | Set to true if the bastion needs to be in the VPC that has VPN access to campus | false                                                  |
| netid             | string       | Your Net ID (for naming the bastion)                                            |                                                        |
| public_key        | string       | Public SSH Key (e.g. \"ssh-rsa AA....Qw== comment\").                           |                                                        |
| ingress_cidrs     | list(string) | IP Address Ranges that should have access to the bastion.                       | ["128.187.0.0/16", "10.0.0.0/8"]                       |
| subnet_type       | string       | Which subnet type sould the bastion launch in? (e.g. public, private, data)     | "public"                                               |
| site_url          | string       | The static URL to use as an alias to the bastion host address.                  | "${var.netid}-bastion.${module.acs.route53_zone.name}" |
| site_zone_id      | string       | The ID of the hosted zone to contain the site_url record.                       | module.acs.route53_zone.zone_id                        |

Notes on `subnet_type`:

* `public` is useful for troubleshooting when your target is inside AWS.
  But the public subnets don't have routing to the VPN, so you won't be
  able to reach back to campus from the bastion.
* `private` is useful for troubleshooting connections back to campus
  across the VPN. But you won't be able to reach the bastion publicly
  from your workstation.
* If you need a `private` bastion, you'll either need to reach it across
  the VPN (i.e. be running the dc vpn on your workstation), or spin up a
  second "public" bastion to go through.

## Output

| Name           | Type                                                                                                                      | Description                                                   |
|:---------------|:--------------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------|
| connect        | string                                                                                                                    | SSH connection details for the bastion                        |
| ec2_instance   | [object](https://www.terraform.io/docs/providers/aws/r/instance.html#attributes-reference)                                | The bastion EC2 Instance                                      |
| security_group | [object](https://www.terraform.io/docs/providers/aws/r/security_group.html#attributes-reference)                          | The security group that controls access to the bastion        |
| key_pair       | [object](https://www.terraform.io/docs/providers/aws/r/key_pair.html#attributes-reference)                                | The SSH keypair assigned to the bastion                       |
| route53_record | [object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#attributes-reference) | The Route53 "A" Record to alias the bastion public IP address |

## Resources

* An EC2 Instance (the bastion) in a public subnet
* A Security Group allowing SSH on port 22 from campus
* A keypair using the public key input variable (granting access to the
  EC2 instance)

