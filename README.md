# terraform-aws-bastion
Create a temporary bastion in an AWS Account

## Usage

### Command Line Example
Best practice is for the bastion to be short lived. Just long enough to perform some troubleshooting or operational task. Then destroy it.

To accomplish this, you can run this directly on the command line:

```shell
git clone git@github.com:byu-oit/terraform-aws-bastion.git
cd terraform-aws-bastion
terrafrom init
terraform apply -var "env=prd" -var "vpc_vpn_to_campus=true" -var "netid=mynetid" -var "public_key=$(cat ~/.ssh/id_rsa.pub)"

```
Which will create the bastion and give you the connection details.

When you're done, run:

```
terraform destroy -var "env=prd" -var "vpc_vpn_to_campus=true" -var "netid=mynetid" -var "public_key=$(cat ~/.ssh/id_rsa.pub)"
```

### Module Example
Alternatively, you can use this template as a module. This way you don't have to clone the repo, and your variables are saved in a template for later use.

In a clean directory, create a `main.tf` file that looks like:

```hcl
module "bastion" {
  source            = "git@github.com:byu-oit/terraform-aws-bastion.git?ref=v1.0.1"
  env               = "prd"
  vpc_vpn_to_campus = true
  netid             = "mynetid"
  public_key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwWVPlHpRiXGBmB/VG6PUeJ/Ev+Y39n5PBI4DW3ZMDT1g32nEUjzKtxK6KwVzYFQBhReMO2ry4uSTiNIzuOtHk/OCfcdPc8wbW3RlHBgbqs6p7DfYRJAXJCnWEjovijaVY0lyL4+7/YuprZwBaA2NfUIRN8UwVxZck3ULMnCK6BKog0UAE9NQZ9Z0vAtgLYPo9eVJEuGrxEszN29X+4Fl6u3T8x0XQ9EoMWU4YNwKfzBIof3th9Cbv4+FlEKpOFYuCc5vB2NPotalN8phEUqnvtsDkmCLAop6+MrUlnNNYIzmh2RLeqDF+M/ZnX8xb+V/mT9vARVcdcYCxKYeyXLvT example"
  #ingress_cidrs     = ["128.187.112.21/32"] # optional (defaults to BYU Campus)
}

output "connect" {
	value = module.bastion.connect
}
```

You need to update the variable values. (i.e. use your netid, your public ssh key, etc.)

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
The bastion is really intended to be ephemeral (spin it up, use it, tear it down). So there's no need for a backend.

## Input
| Name | Description | Default Value |
| --- | --- | --- |
| env | Environment of the AWS Account (for finding the shared VPC and tagging the bastion) (e.g. dev, prd)|  |
| vpc_vpn_to_campus | Retrieve VPC info for the VPC that has VPN access to campus | false |
| netid | Your Net ID (for naming the bastion) | |
| public_key | Public SSH Key (e.g. \"ssh-rsa AA....Qw== comment\"). | |
| ingress_cidrs | IP Address Ranges that should have access to the bastion. | ["128.187.0.0/16"] |

## Output
| Name | Description |
| --- | --- |
| connect | SSH connection details for the bastion |

## Resources
* An EC2 Instance (the bastion) in a public subnet
* A Security Group allowing SSH on port 22 from campus
* A keypair using the public key input variable (granting access to the EC2 instance)