output "vpc_details" {
  description = "VPC Details"
  value = {
    id   = aws_vpc.this.id
    arn  = aws_vpc.this.arn
    name = aws_vpc.this.tags_all["Name"]
  }
}

output "igw_details" {
  description = "Internet Gateway details"
  value = {
    id  = aws_internet_gateway.this.id
    arn = aws_internet_gateway.this.arn
  }
}

output "subnet_details" {
  description = "Subnet details"
  value = {
    for k, v in aws_subnet.this : k => {
      name = k
      id   = v.id
      arn  = v.arn
      az   = v.availability_zone
      cidr = v.cidr_block
    }
  }
}

output "alb_details" {
  description = "Application Load Balancer details"
  value = {
    alb_id       = aws_lb.this.id
    alb_name     = aws_lb.this.name
    alb_dns_name = aws_lb.this.dns_name
    sg_arn       = aws_security_group.alb.arn
    sg_id        = aws_security_group.alb.id
    sg_name      = aws_security_group.alb.name
  }
}
