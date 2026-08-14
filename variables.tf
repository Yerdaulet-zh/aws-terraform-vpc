variable "vpc_config" {
  description = "Default configuration for the VPC"
  type = object({
    ipv4_ipam_id                         = string
    ipv4_netmask_length                  = number
    ipv4_cidr_block                      = string
    assign_generated_ipv6_cidr_block     = bool
    instance_tenancy                     = string
    enable_dns_support                   = bool
    enable_network_address_usage_metrics = bool
    enable_dns_hostnames                 = bool
    tags = object({
      Owner     = string
      ManagedBy = string
    })
  })
  default = {
    ipv4_ipam_id                         = null,
    ipv4_netmask_length                  = null,
    ipv4_cidr_block                      = "10.0.0.0/16",
    assign_generated_ipv6_cidr_block     = true
    instance_tenancy                     = "default"
    enable_dns_support                   = true
    enable_network_address_usage_metrics = true
    enable_dns_hostnames                 = true
    tags = {
      Owner     = "Terraform"
      ManagedBy = "Terraform"
    }
  }
}
