locals {
  # This conditional block for vpc cidr block definition
  vpc_config = var.vpc_config.ipv4_ipam_id != null ? {
    ipv4_ipam_pool_id   = var.vpc_config.ipv4_ipam_id
    ipv4_netmask_length = var.vpc_config.ipv4_netmask_length
    } : {
    cidr_block = var.vpc_config.ipv4_cidr_block
  }
}
