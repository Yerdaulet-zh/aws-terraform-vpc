resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = local.default_tags
}
