module "vpc_test" {
  source = "../"

  vpc_config = {
    ipv4_ipam_id                         = null
    ipv4_netmask_length                  = null
    ipv4_cidr_block                      = "10.100.0.0/16"
    assign_generated_ipv6_cidr_block     = true
    instance_tenancy                     = "default"
    enable_dns_support                   = true
    enable_network_address_usage_metrics = true
    enable_dns_hostnames                 = true
    tags = {
      Owner     = "DevOpsTeam"
      ManagedBy = "Terraform"
    }
  }
}
