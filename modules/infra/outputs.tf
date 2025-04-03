output "vpc_details" {
  value = {
    id   = aws_vpc.this.id
    arn  = aws_vpc.this.arn
    name = aws_vpc.this.tags_all["Name"]
  }
}

output "igw_details" {
  value = {
    id  = aws_internet_gateway.this.id
    arn = aws_internet_gateway.this.arn
  }
}
