resource "aws_default_network_acl" "default" {
  count = try(length(var.acl.rules), 0) > 0 ? 1 : 0

  default_network_acl_id = aws_vpc.this.default_network_acl_id

  lifecycle {
    ignore_changes = [subnet_ids]
  }

  dynamic "ingress" {
    for_each = {
      for k, v in var.acl.rules : k => v
      if !v.egress
    }

    content {
      rule_no         = ingress.value.rule_number
      action          = ingress.value.rule_action
      protocol        = ingress.value.protocol
      cidr_block      = ingress.value.cidr_block
      ipv6_cidr_block = ingress.value.ipv6_cidr_block
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = {
      for k, v in var.acl.rules : k => v
      if v.egress
    }

    content {
      rule_no         = egress.value.rule_number
      action          = egress.value.rule_action
      protocol        = egress.value.protocol
      cidr_block      = egress.value.cidr_block
      ipv6_cidr_block = egress.value.ipv6_cidr_block
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
    }
  }

  tags = try(var.acl.tags, {})
}
