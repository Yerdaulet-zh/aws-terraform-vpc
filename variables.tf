variable "global" {
  description = "Global variables for the project"
  type = object({
    project_name = string
    environment  = string
    region       = string
  })
}

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
    tags                                 = optional(map(string), {})
  })

  # Require either IPv4 CIDR block or IPAM Pool ID
  validation {
    condition     = var.vpc_config.ipv4_ipam_id != null || var.vpc_config.ipv4_cidr_block != null
    error_message = "You must provide either 'ipv4_cidr_block' or 'ipv4_ipam_id' in vpc_config."
  }

  # Require netmask length when using IPAM
  validation {
    condition = var.vpc_config.ipv4_ipam_id != null ? (
      var.vpc_config.ipv4_netmask_length != null
    ) : true
    error_message = "'ipv4_netmask_length' must be specified when using 'ipv4_ipam_id'."
  }

  # Prevent conflict between Amazon-provided IPv6 and IPAM IPv6
  validation {
    condition = var.vpc_config.ipv6_ipam_pool_id != null ? (
      var.vpc_config.assign_generated_ipv6_cidr_block == null || var.vpc_config.assign_generated_ipv6_cidr_block == false
    ) : true
    error_message = "Cannot set 'assign_generated_ipv6_cidr_block = true' when using 'ipv6_ipam_pool_id'."
  }
}

variable "acl" {
  description = "Configuration for the default network ACL"

  type = object({
    tags = optional(map(string), {})
    rules = optional(map(object({
      rule_number     = number
      egress          = bool
      protocol        = string
      cidr_block      = optional(string)
      ipv6_cidr_block = optional(string)
      rule_action     = string
      from_port       = optional(number, 0)
      to_port         = optional(number, 65535)
    })))
  })

  default = {}
}

variable "subnets" {
  description = "All types of subnet configurations"
  type = map(object({
    availability_zone = string
    ipv6_native       = optional(bool, false)

    subnet_ipv4_cidr = optional(object({
      newbits = number
      netnum  = number
    }))

    subnet_ipv6_cidr = optional(object({
      newbits = number
      netnum  = number
    }))

    map_public_ip_on_launch                        = optional(bool, false)
    assign_ipv6_address_on_creation                = optional(bool, false)
    enable_resource_name_dns_aaaa_record_on_launch = optional(bool, false)
    enable_dns64                                   = optional(bool, false)

    tags = optional(map(string), {})
  }))

  # At least one subnet must be provided
  validation {
    condition     = length(var.subnets) > 0
    error_message = "You must provide at least one subnet configuration."
  }

  # IPv6-native subnets MUST NOT have IPv4 CIDR blocks
  validation {
    condition = alltrue([
      for k, v in var.subnets :
      v.ipv6_native ? v.subnet_ipv4_cidr == null : true
    ])
    error_message = "IPv6-native subnets (ipv6_native = true) must NOT have 'subnet_ipv4_cidr' configured."
  }

  # Standard subnets MUST have an IPv4 CIDR block
  validation {
    condition = alltrue([
      for k, v in var.subnets :
      !v.ipv6_native ? v.subnet_ipv4_cidr != null : true
    ])
    error_message = "Standard (non-IPv6-native) subnets must have 'subnet_ipv4_cidr' defined."
  }

  # IPv6-native subnets CANNOT enable public IPv4 auto-assignment
  validation {
    condition = alltrue([
      for k, v in var.subnets :
      v.ipv6_native ? !v.map_public_ip_on_launch : true
    ])
    error_message = "IPv6-native subnets cannot set 'map_public_ip_on_launch' to true because they do not support IPv4."
  }

  # IPv6-native subnets MUST have an IPv6 CIDR block
  validation {
    condition = alltrue([
      for k, v in var.subnets :
      v.ipv6_native ? v.subnet_ipv6_cidr != null : true
    ])
    error_message = "IPv6-native subnets (ipv6_native = true) MUST have 'subnet_ipv6_cidr' defined."
  }

  # Enabling DNS64 requires an IPv6 CIDR block
  validation {
    condition = alltrue([
      for k, v in var.subnets :
      v.enable_dns64 ? v.subnet_ipv6_cidr != null : true
    ])
    error_message = "'enable_dns64' can only be set to true if 'subnet_ipv6_cidr' is provided."
  }

  # Auto-assigning IPv6 requires an IPv6 CIDR block
  validation {
    condition = alltrue([
      for k, v in var.subnets :
      v.assign_ipv6_address_on_creation ? v.subnet_ipv6_cidr != null : true
    ])
    error_message = "'assign_ipv6_address_on_creation' can only be set to true if 'subnet_ipv6_cidr' is provided."
  }

  # Bounds check on IPv4 CIDR calculation
  validation {
    condition = alltrue([
      for k, v in var.subnets :
      v.subnet_ipv4_cidr == null ? true : (
        v.subnet_ipv4_cidr.newbits > 0 && v.subnet_ipv4_cidr.netnum >= 0
      )
    ])
    error_message = "For 'subnet_ipv4_cidr', 'newbits' must be greater than 0 and 'netnum' must be 0 or greater."
  }

  # Bounds check on IPv6 CIDR calculation
  validation {
    condition = alltrue([
      for k, v in var.subnets :
      v.subnet_ipv6_cidr == null ? true : (
        v.subnet_ipv6_cidr.newbits > 0 && v.subnet_ipv6_cidr.netnum >= 0
      )
    ])
    error_message = "For 'subnet_ipv6_cidr', 'newbits' must be greater than 0 and 'netnum' must be 0 or greater."
  }
}
