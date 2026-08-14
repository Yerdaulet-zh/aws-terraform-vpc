# Core Terraform syntax & best-practice rules
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# AWS-specific resource rules
plugin "aws" {
  enabled = true
  version = "0.48.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

config {
  # Acceptable values: "local", "all", or "none"
  call_module_type = "local"
}
