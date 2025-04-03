# output "vpc_id" {
#   value = aws_vpc.this.id
# }

# output "vpc_arn" {
#   value = aws_vpc.this.arn
# }

output "vpc_details" {
  value = {
    id   = aws_vpc.this.id
    arn  = aws_vpc.this.arn
    name = aws_vpc.this.tags_all["Name"]
  }
}
