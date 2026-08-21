resource "aws_internet_gateway" "igw" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = merge(local.default_tags, { Name = "${var.global.project_name}-igw" })
}
