resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.global.project_name}-${var.global.environment}-igw"
  }
}
