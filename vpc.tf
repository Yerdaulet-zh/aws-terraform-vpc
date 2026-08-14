resource "aws_vpc" "main" {
  # If the key isn't in the map, return null
  ipv4_ipam_pool_id   = lookup(local.vpc_config, "ipv4_ipam_pool_id", null)
  ipv4_netmask_length = lookup(local.vpc_config, "ipv4_netmask_length", null)
  cidr_block          = lookup(local.vpc_config, "cidr_block", null)

  instance_tenancy                     = var.vpc_config.instance_tenancy
  enable_dns_support                   = var.vpc_config.enable_dns_support
  enable_network_address_usage_metrics = var.vpc_config.enable_network_address_usage_metrics
  enable_dns_hostnames                 = var.vpc_config.enable_dns_hostnames

  tags = var.vpc_config.tags
}
