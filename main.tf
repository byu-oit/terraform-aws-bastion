terraform {
  required_version = ">= 0.12.16"
}

provider "aws" {
  version = ">= 2.38.0"
  region  = "us-west-2"
}

module "acs" {
  source            = "git@github.com:byu-oit/terraform-aws-acs-info.git?ref=v1.1.0"
  env               = var.env
  vpc_vpn_to_campus = var.vpc_vpn_to_campus
}

resource "aws_instance" "bastion" {
  ami                    = "ami-0c5204531f799e0c6"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key.key_name
  subnet_id              = module.acs["${var.subnet_type}_subnet_ids"][0]
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name             = "${var.netid}-bastion"
    app              = "${var.netid}-bastion"
    env              = var.env
    data-sensitivity = "internal"
  }
}

resource "aws_security_group" "sg" {
  name        = "${var.netid}-bastion"
  description = "${var.netid}-bastion"
  vpc_id      = module.acs.vpc.id

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

  tags = {
    Name             = "${var.netid}-bastion"
    app              = "${var.netid}-bastion"
    env              = var.env
    data-sensitivity = "internal"
  }
}

resource "aws_key_pair" "key" {
  key_name   = "${var.netid}-bastion"
  public_key = var.public_key
}
