#!/bin/bash
# run from root of repo
terraform destroy -var "env=prd" -var "vpc_vpn_to_campus=true" -var "netid=mynetid" -var "public_key=$(cat ~/.ssh/id_rsa.pub)"
