variable "env" {
  type        = string
  description = "Account environment (for finding the shared VPC and tagging the bastion) (e.g. dev, prd)."
}

variable "vpc_vpn_to_campus" {
  type        = bool
  description = "Retrieve VPC info for the VPC that has VPN access to campus."
}

variable "netid" {
  type        = string
  description = "Your Net ID (for naming the bastion)."
}

variable "public_key" {
  type        = string
  description = "Public SSH Key (e.g. \"ssh-rsa AA....Qw== comment\")."
}
