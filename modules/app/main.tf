resource "aws_ecr_repository" "this" {
  name         = var.ecr_repo_name
  force_delete = true
}
