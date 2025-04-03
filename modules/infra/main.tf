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

resource "aws_subnet" "this" {
  for_each   = { for i in range(var.num_subnets) : "ecs-public-subnet-${i}" => i }
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 8, each.value)
  availability_zone = local.azs[
    each.value % length(local.azs)
  ]

  tags = {
    Name = "${each.key}"
  }
}

resource "aws_route_table_association" "this" {
  for_each       = aws_subnet.this
  subnet_id      = each.value.id
  route_table_id = aws_route_table.this.id
}

resource "aws_lb" "this" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for subnet in aws_subnet.this : subnet.id]
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    # type             = "forward"
    # target_group_arn = aws_lb_target_group.this.arn
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "All G here!"
      status_code  = "503"
    }
  }
}

resource "aws_security_group" "alb" {
  name   = "ecs-alb-sg"
  vpc_id = aws_vpc.this.id
  # tags = {
  #   Name = "ecs-alb-sg"
  # }
}

resource "aws_vpc_security_group_ingress_rule" "alb" {
  for_each          = var.allowed_ips
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = each.value
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}
