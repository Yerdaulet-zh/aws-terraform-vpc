resource "aws_route_table" "private" {
  count  = length(local.private_ipv6_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(local.default_tags, { Name = "${var.global.project_name}-private-rt" })
}

# IPv6 Outbound-Only Egress via EOIGW
resource "aws_route" "private_eoigw" {
  count                       = local.has_ipv6_private && length(aws_egress_only_internet_gateway.this) > 0 ? 1 : 0
  route_table_id              = aws_route_table.private[0].id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this[0].id
}

resource "aws_route_table_association" "private" {
  for_each       = local.private_ipv6_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[0].id
}
