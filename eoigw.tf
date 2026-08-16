resource "aws_egress_only_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = local.default_tags
}
