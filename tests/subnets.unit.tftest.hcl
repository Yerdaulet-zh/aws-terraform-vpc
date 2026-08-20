run "setup" {
  command = plan

  variables {
    global = {
      region           = "eu-central-1"
      project_name     = "demo"
      eks_cluster_name = "demo-cluster"
    }
  }
}

# Empty subnets map
run "fail_empty_subnets" {
  command = plan

  variables {
    subnets = {}
  }

  expect_failures = [var.subnets]
}

# IPv6-native with IPv4 CIDR provided
run "fail_ipv6_native_with_ipv4_cidr" {
  command = plan

  variables {
    subnets = {
      bad_subnet = {
        availability_zone = "a"
        ipv6_native       = true
        subnet_ipv4_cidr  = { newbits = 8, netnum = 1 }
        subnet_ipv6_cidr  = { newbits = 8, netnum = 1 }
      }
    }
  }

  expect_failures = [var.subnets]
}

# Standard subnet missing IPv4 CIDR
run "fail_standard_subnet_missing_ipv4_cidr" {
  command = plan

  variables {
    subnets = {
      bad_subnet = {
        availability_zone = "a"
        ipv6_native       = false
        subnet_ipv4_cidr  = null
      }
    }
  }

  expect_failures = [var.subnets]
}

# Public IPv4 mapping on IPv6-native subnet
run "fail_public_ipv4_on_ipv6_native" {
  command = plan

  variables {
    subnets = {
      bad_subnet = {
        availability_zone       = "a"
        ipv6_native             = true
        map_public_ip_on_launch = true
        subnet_ipv6_cidr        = { newbits = 8, netnum = 1 }
      }
    }
  }

  expect_failures = [var.subnets]
}

# IPv6-native missing IPv6 CIDR
run "fail_ipv6_native_missing_ipv6_cidr" {
  command = plan

  variables {
    subnets = {
      bad_subnet = {
        availability_zone = "a"
        ipv6_native       = true
        subnet_ipv6_cidr  = null
      }
    }
  }

  expect_failures = [var.subnets]
}

# Enabling DNS64 without IPv6 CIDR
run "fail_dns64_without_ipv6_cidr" {
  command = plan

  variables {
    subnets = {
      bad_subnet = {
        availability_zone = "a"
        enable_dns64      = true
        subnet_ipv4_cidr  = { newbits = 8, netnum = 1 }
        subnet_ipv6_cidr  = null
      }
    }
  }

  expect_failures = [var.subnets]
}

# Auto-assign IPv6 without IPv6 CIDR
run "fail_assign_ipv6_without_ipv6_cidr" {
  command = plan

  variables {
    subnets = {
      bad_subnet = {
        availability_zone               = "a"
        assign_ipv6_address_on_creation = true
        subnet_ipv4_cidr                = { newbits = 8, netnum = 1 }
        subnet_ipv6_cidr                = { newbits = 8, netnum = 1 }
      }
    }
  }

  expect_failures = [var.subnets]
}

# Negative netnum for IPv4 CIDR
run "fail_invalid_ipv4_netnum" {
  command = plan

  variables {
    subnets = {
      bad_subnet = {
        availability_zone = "a"
        subnet_ipv4_cidr  = { newbits = 8, netnum = -1 }
      }
    }
  }

  expect_failures = [var.subnets]
}

# Valid inputs (Standard dual-stack + IPv6-native)
run "pass_valid_configurations" {
  command = plan

  variables {
    subnets = {
      public_a = {
        availability_zone               = "a"
        map_public_ip_on_launch         = true
        assign_ipv6_address_on_creation = true
        subnet_ipv4_cidr                = { newbits = 8, netnum = 1 }
        subnet_ipv6_cidr                = { newbits = 8, netnum = 1 }
      }
      ipv6_only_b = {
        availability_zone = "b"
        ipv6_native       = true
        enable_dns64      = true
        subnet_ipv6_cidr  = { newbits = 8, netnum = 2 }
      }
    }
  }
}