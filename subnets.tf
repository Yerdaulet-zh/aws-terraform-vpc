resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id            = aws_vpc.this.id
  availability_zone = "${var.global.region}${each.value.availability_zone}"
  ipv6_native       = each.value.ipv6_native

  cidr_block = each.value.subnet_ipv4_cidr != null ? cidrsubnet(
    aws_vpc.this.cidr_block,
    each.value.subnet_ipv4_cidr.newbits,
    each.value.subnet_ipv4_cidr.netnum
  ) : null

  ipv6_cidr_block = each.value.subnet_ipv6_cidr != null ? cidrsubnet(
    aws_vpc.this.ipv6_cidr_block,
    each.value.subnet_ipv6_cidr.newbits,
    each.value.subnet_ipv6_cidr.netnum
  ) : null

  map_public_ip_on_launch                        = each.value.map_public_ip_on_launch
  assign_ipv6_address_on_creation                = each.value.assign_ipv6_address_on_creation
  enable_resource_name_dns_aaaa_record_on_launch = each.value.enable_resource_name_dns_aaaa_record_on_launch
  enable_dns64                                   = each.value.enable_dns64

  tags = each.value.tags
}
