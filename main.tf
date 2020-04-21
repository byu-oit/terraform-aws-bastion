terraform {
  required_version = ">= 0.12.16"
  required_providers {
    aws = ">= 2.42"
  }
}

module "acs" {
  source            = "github.com/byu-oit/terraform-aws-acs-info.git?ref=v2.1.0"
  vpc_vpn_to_campus = var.vpc_vpn_to_campus
}

locals {
  tags = {
    Name             = "${var.netid}-bastion"
    app              = "${var.netid}-bastion"
    env              = var.env
    data-sensitivity = "internal"
  }
}

data "aws_ssm_parameter" "ami" {
	name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key.key_name
  subnet_id              = module.acs["${var.subnet_type}_subnet_ids"][0]
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = local.tags
}

resource "aws_security_group" "sg" {
  name        = "${var.netid}-bastion"
  description = "${var.netid}-bastion"
  vpc_id      = module.acs.vpc.id
  tags = local.tags

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "key" {
  key_name   = "${var.netid}-bastion"
  public_key = var.public_key
}
