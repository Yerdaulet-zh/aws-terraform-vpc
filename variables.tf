variable "vpc_config" {
  description = "Default configuration for the VPC"
  type = object({
    ipv4_ipam_id                         = optional(string)
    ipv4_netmask_length                  = optional(number)
    ipv4_cidr_block                      = optional(string, "10.0.0.0/16")
    assign_generated_ipv6_cidr_block     = optional(bool, true)
    instance_tenancy                     = optional(string, "default")
    enable_dns_support                   = optional(bool, true)
    enable_network_address_usage_metrics = optional(bool, true)
    enable_dns_hostnames                 = optional(bool, true)
    tags = optional(map(string), {
      Owner     = "Terraform"
      ManagedBy = "Terraform"
    })
  })
}
