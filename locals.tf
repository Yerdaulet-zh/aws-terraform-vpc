locals {
  default_tags = {
    Name        = "${var.global.project_name}-${var.global.environment}"
    Environment = var.global.environment
    Owner       = "Terraform"
    ManagedBy   = "DevOpsTeam"
  }
}
