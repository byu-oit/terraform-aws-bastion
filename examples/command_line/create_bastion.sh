#!/bin/bash
# run from root of repo

# to accept the default CIDR (BYU Campus)
terraform apply -var "env=prd" -var "vpc_vpn_to_campus=true" -var "netid=mynetid" -var "public_key=$(cat ~/.ssh/id_rsa.pub)"

# to specify a specific CIDR (e.g. your ip address)
terraform apply -var "env=prd" -var "vpc_vpn_to_campus=true" -var "netid=mynetid" -var "public_key=$(cat ~/.ssh/id_rsa.pub)" -var "ingress_cidrs=[\"128.187.112.21/32\"]"
