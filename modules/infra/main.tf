resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "ecs-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  tags = {
    Name = "ecs-igw"
  }
}

resource "aws_internet_gateway_attachment" "this" {
  internet_gateway_id = aws_internet_gateway.this.id
  vpc_id              = aws_vpc.this.id
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "ecs-route-table"
  }
}

resource "aws_route" "this" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}
