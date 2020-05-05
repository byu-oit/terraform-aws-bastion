# How to get into a private subnet (to test AWS connectivity back to campus)

## Why
Our public subnets don't have routes to the VPN back to campus. Our private subnets don't have public ingress from the internet. So to test AWS connectivity back to campus you have to stand up a public bastion and a private bastion, and then hop from the public bastion to the private bastion.

SSH makes this "double-hop" easy with the use of the "ProxyJump" setting in your ssh config.

## Instuctions
1. Update locals in doubl_hop.tf
2. run `terraform apply`
3. copy `ssh_config` output to your `~/.ssh/config` file (e.g. `terraform output ssh_config >> ~/.ssh/config`)
4. run `ssh private-bastion`
5. test connection back to campus (ping, telnet, mysql, ssh, etc.)