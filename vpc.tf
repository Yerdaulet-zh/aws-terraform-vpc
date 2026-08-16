resource "aws_vpc" "main" {
  # IPv4 Configuration
  cidr_block          = var.vpc_config.ipv4_ipam_id == null ? var.vpc_config.ipv4_cidr_block : null
  ipv4_ipam_pool_id   = var.vpc_config.ipv4_ipam_id
  ipv4_netmask_length = var.vpc_config.ipv4_ipam_id != null ? var.vpc_config.ipv4_netmask_length : null

  # IPv6 Configuration
  ipv6_ipam_pool_id                = var.vpc_config.ipv6_ipam_pool_id
  ipv6_netmask_length              = var.vpc_config.ipv6_ipam_pool_id != null ? var.vpc_config.ipv6_netmask_length : null
  assign_generated_ipv6_cidr_block = var.vpc_config.ipv6_ipam_pool_id == null ? var.vpc_config.assign_generated_ipv6_cidr_block : null

  # General Attributes
  instance_tenancy                     = var.vpc_config.instance_tenancy
  enable_dns_support                   = var.vpc_config.enable_dns_support
  enable_network_address_usage_metrics = var.vpc_config.enable_network_address_usage_metrics
  enable_dns_hostnames                 = var.vpc_config.enable_dns_hostnames

  tags = var.vpc_config.tags
}
