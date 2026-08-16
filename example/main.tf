module "vpc_test" {
  source = "../"

  vpc_config = {
    ipv4_cidr_block = "10.100.0.0/16"
    tags = {
      Owner     = "DevOpsTeam"
      ManagedBy = "Terraform"
    }
  }
}
