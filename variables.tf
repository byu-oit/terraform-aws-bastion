variable "env" {
  type        = string
  description = "Environment (for tagging the bastion) (e.g. dev, prd)."
}

variable "vpc_vpn_to_campus" {
  type        = bool
  description = "Set to true if the bastion needs to be in the VPC that has VPN access to campus."
}

variable "netid" {
  type        = string
  description = "Your Net ID (for naming the bastion)."
}

variable "public_key" {
  type        = string
  description = "Public SSH Key (e.g. \"ssh-rsa AA....Qw== comment\")."
}

variable "ingress_cidrs" {
  type        = list(string)
  default     = ["128.187.0.0/16", "10.0.0.0/8"]
  description = "IP Address Ranges that should have access to the bastion."
}

variable "subnet_type" {
  type        = string
  default     = "public"
  description = "Which subnet type should the bastion launch in? (e.g. public, private, data)"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "The EC2 instance type to deploy (defaults to t3.micro)."
}

variable "site_url" {
  type        = string
  default     = null
  description = "The static URL to use as an alias to the bastion host address (defaults to {var.netid}-bastion.{module.acs.route53_zone.name})."
}

variable "site_zone_id" {
  type        = string
  default     = null
  description = "The ID of the hosted zone to contain the site_url record (defaults to module.acs.route53_zone.zone_id)."
}
