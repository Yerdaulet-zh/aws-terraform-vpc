resource "aws_route_table" "public" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(local.default_tags, { Name = "${var.global.project_name}-public-rt" })
}

# IPv4 Ingress/Egress via IGW
resource "aws_route" "public_ipv4" {
  count                  = local.has_ipv4_public && length(aws_internet_gateway.igw) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
}

# IPv6 Ingress/Egress via IGW
resource "aws_route" "public_ipv6" {
  count                       = local.has_ipv6_public && length(aws_internet_gateway.igw) > 0 ? 1 : 0
  route_table_id              = aws_route_table.public[0].id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.igw[0].id
}

resource "aws_route_table_association" "public" {
  for_each       = local.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}
