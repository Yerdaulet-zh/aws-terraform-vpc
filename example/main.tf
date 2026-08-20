module "vpc_test" {
  source = "../"

  global = {
    project_name = "vpc-module-example"
    environment  = "dev"
    region       = "eu-central-1"
  }

  vpc_config = {
    ipv4_cidr_block                  = "10.100.0.0/16"
    assign_generated_ipv6_cidr_block = true
  }

  subnets = {
    "public-a" = {
      availability_zone = "a"
      subnet_ipv4_cidr  = { newbits = 8, netnum = 1 }
      subnet_ipv6_cidr  = { newbits = 8, netnum = 1 }

      map_public_ip_on_launch         = true
      assign_ipv6_address_on_creation = true

      tags = {
        Name = "Dual-Stack Public Subnet A"
      }
    }

    "private-a" = {
      availability_zone = "a"
      subnet_ipv4_cidr  = { newbits = 8, netnum = 10 }
      subnet_ipv6_cidr  = { newbits = 8, netnum = 10 }

      tags = {
        Name = "Dual-Stack Private Subnet A"
      }
    }

    "ipv4-only-b" = {
      availability_zone = "b"
      subnet_ipv4_cidr  = { newbits = 8, netnum = 2 }

      tags = {
        Name = "IPv4 Only Subnet B"
      }
    }

    "ipv6-native-a" = {
      availability_zone = "a"
      ipv6_native       = true
      subnet_ipv6_cidr  = { newbits = 8, netnum = 100 }

      assign_ipv6_address_on_creation                = true
      enable_dns64                                   = true
      enable_resource_name_dns_aaaa_record_on_launch = true

      tags = {
        Name = "IPv6 Native Subnet A"
      }
    }
  }
}
