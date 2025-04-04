# Contains definitions for the security groups so they are easier to maintain
# SG for the Load Balancer
resource "aws_security_group" "alb" {
  name   = "ecs-alb-sg"
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "ecs-alb-sg"
  }
}

# Ingress rule: world -> ALB
resource "aws_vpc_security_group_ingress_rule" "alb" {
  for_each          = var.allowed_ips
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = each.value
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
  tags = {
    Name = "alb-ingress-allow-all"
  }
}

# Exgress rule: alb -> app
resource "aws_vpc_security_group_egress_rule" "alb" {
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "-1"
  tags = {
    Name = "alb-egress-all-to-app"
  }
}

# SG for the app module used by the App ECS Service
resource "aws_security_group" "app" {
  name   = "${var.app_name}-sg"
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.app_name}-sg"
  }
}

# Ingress Rule: ALB -> App
resource "aws_vpc_security_group_ingress_rule" "app" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "-1"
  tags = {
    Name = "app-ingress-all-from-alb"
  }
}

# Egress Rule: App -> World
resource "aws_vpc_security_group_egress_rule" "app" {
  for_each          = var.allowed_ips
  security_group_id = aws_security_group.app.id

  cidr_ipv4   = each.value
  ip_protocol = "-1"
  tags = {
    Name = "app-egress-all-to-world"
  }
}
