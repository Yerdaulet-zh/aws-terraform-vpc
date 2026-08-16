variable "vpc_config" {
  description = "Default configuration for the VPC"
  type = object({
    ipv4_ipam_id        = optional(string)
    ipv4_netmask_length = optional(number)
    ipv4_cidr_block     = optional(string)

    ipv6_ipam_pool_id                = optional(string)
    ipv6_netmask_length              = optional(number)
    assign_generated_ipv6_cidr_block = optional(bool)

    instance_tenancy                     = optional(string, "default")
    enable_dns_support                   = optional(bool, true)
    enable_network_address_usage_metrics = optional(bool, true)
    enable_dns_hostnames                 = optional(bool, true)
    tags = optional(map(string), {
      Name        = "${var.global.project_name}-${var.global.environment}"
      Environment = "${var.global.environment}"
      Owner       = "Terraform"
      ManagedBy   = "Terraform"
    })
  })

  validation {
    condition     = var.vpc_config.ipv4_ipam_id != null || var.vpc_config.ipv4_cidr_block != null
    error_message = "You must provide either 'ipv4_cidr_block' or 'ipv4_ipam_id' in vpc_config."
  }
}

variable "global" {
  description = "Global variables for the project"
  type = object({
    project_name = string
    environment  = string
  })
}
