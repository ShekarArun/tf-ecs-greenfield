resource "aws_ecr_repository" "this" {
  name         = "ecr-repo"
  force_delete = true
}
