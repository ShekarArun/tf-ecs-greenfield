output "ecr_details" {
  description = "ECR Repository details"
  value = {
    name           = aws_ecr_repository.this.name
    arn            = aws_ecr_repository.this.arn
    registry_id    = aws_ecr_repository.this.registry_id
    repository_url = aws_ecr_repository.this.repository_url
  }
}
