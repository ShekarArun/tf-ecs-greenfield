locals {
  ecr_url   = aws_ecr_repository.this.repository_url
  ecr_token = data.aws_ecr_authorization_token.this
}
