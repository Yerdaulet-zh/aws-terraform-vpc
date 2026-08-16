module "vpc_test" {
  source = "../"

  vpc_config = {
    # ipv4_cidr_block                  = "10.100.0.0/16"
    assign_generated_ipv6_cidr_block = true
    tags = {
      Name      = "vpc-module-example"
      Owner     = "DevOpsTeam"
      ManagedBy = "Terraform"
    }
  }
}
