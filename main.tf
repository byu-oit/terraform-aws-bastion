terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = ">= 4.2"
  }
}

module "acs" {
  source            = "github.com/byu-oit/terraform-aws-acs-info.git?ref=v4.0.0"
  vpc_vpn_to_campus = var.vpc_vpn_to_campus
}

locals {
  tags = {
    Name             = "${var.netid}-bastion"
    app              = "${var.netid}-bastion"
    env              = var.env
    data-sensitivity = "internal"
  }

  app_domain_name = var.site_url != null ? var.site_url : "${var.netid}-bastion.${module.acs.route53_zone.name}"
  app_zone_id     = var.site_url != null && var.site_zone_id != null ? var.site_zone_id : module.acs.route53_zone.zone_id
}

# ==================== Bastion ====================
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key.key_name
  subnet_id              = module.acs["${var.subnet_type}_subnet_ids"][0]
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags                   = local.tags
}

resource "aws_security_group" "sg" {
  name        = "${var.netid}-bastion"
  description = "${var.netid}-bastion"
  vpc_id      = module.acs.vpc.id
  tags        = local.tags

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

# ==================== Route53 ====================
resource "aws_route53_record" "a_record" {
  name    = local.app_domain_name
  type    = "A"
  zone_id = local.app_zone_id
  ttl     = 60
  records = [length(aws_instance.bastion.public_ip) > 0 ? aws_instance.bastion.public_ip : aws_instance.bastion.private_ip]
}
