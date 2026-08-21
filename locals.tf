locals {
  default_tags = {
    Name        = "${var.global.project_name}-${var.global.environment}"
    Environment = var.global.environment
    Owner       = "Terraform"
    ManagedBy   = "DevOpsTeam"
  }

  # Automatically Categorize Subnets which used by IGW, EOIGW, Route Tables, and NAT Gateways
  public_subnets = {
    for k, v in aws_subnet.subnets : k => v
    if try(v.map_public_ip_on_launch, false) || try(v.assign_ipv6_address_on_creation, false)
  }

  all_private_subnets = {
    for k, v in aws_subnet.subnets : k => v
    if !contains(keys(local.public_subnets), k)
  }

  # Split Private Subnets by IPv6 Capability such as IPv6 Native or IPv6 Enabled (Dual-Stack) Subnets
  private_ipv6_subnets = {
    for k, v in local.all_private_subnets : k => v
    if try(v.ipv6_cidr_block, null) != null
  }

  private_ipv4_only_subnets = {
    for k, v in local.all_private_subnets : k => v
    if v.ipv6_cidr_block == null
  }

  # Determine if there are any public IPv4 or IPv6 subnets configured by the user.
  # If no public subnets are configured for IPv4, then route table association will not be created for IPv4, and vise versa.
  # If no public subnets are configured for either IPv4 or IPv6, then the public route table will not be created at all.
  # See: aws_route_table --- count  = length(local.public_subnets) > 0 ? 1 : 0
  has_ipv4_public  = length([for s in local.public_subnets : s if s.cidr_block != null]) > 0
  has_ipv6_public  = length([for s in local.public_subnets : s if s.ipv6_cidr_block != null]) > 0
  has_ipv6_private = length(local.private_ipv6_subnets) > 0
}
