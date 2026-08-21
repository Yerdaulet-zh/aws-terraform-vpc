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
    tags = {
      Name = "Dual-Stack Example VPC"
    }
  }
  acl = {
    tags = {
      Name        = "Default ACL of Example VPC"
      Environment = "production"
      ManagedBy   = "terraform"
    }
    rules = {
      // IPv4 Rules
      "allow_all_ingress_ipv4" = {
        rule_number = 100
        egress      = false
        protocol    = "-1"
        cidr_block  = "0.0.0.0/0"
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
      }
      "allow_all_egress_ipv4" = {
        rule_number = 100
        egress      = true
        protocol    = "-1"
        cidr_block  = "0.0.0.0/0"
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
      }

      // IPv6 rules
      "allow_all_ingress_ipv6" = {
        rule_number     = 101
        egress          = false
        protocol        = "-1"
        ipv6_cidr_block = "::/0"
        rule_action     = "allow"
        from_port       = 0
        to_port         = 0
      }
      "allow_all_egress_ipv6" = {
        rule_number     = 101
        egress          = true
        protocol        = "-1"
        ipv6_cidr_block = "::/0"
        rule_action     = "allow"
        from_port       = 0
        to_port         = 0
      }
    }
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
