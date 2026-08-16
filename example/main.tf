module "vpc_test" {
  source = "../"

  global = {
    project_name = "vpc-module-example"
    environment  = "dev"
  }

  vpc_config = {
    ipv4_cidr_block                  = "10.100.0.0/16"
    assign_generated_ipv6_cidr_block = true
  }
}
