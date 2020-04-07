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
