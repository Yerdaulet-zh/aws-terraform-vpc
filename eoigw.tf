resource "aws_egress_only_internet_gateway" "this" {
  count  = local.has_ipv6_private ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = merge(local.default_tags, { Name = "${var.global.project_name}-eoigw" })
}
