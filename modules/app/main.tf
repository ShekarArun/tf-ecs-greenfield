resource "aws_ecr_repository" "this" {
  name         = var.ecr_repo_name
  force_delete = true
}

resource "terraform_data" "login" {
  provisioner "local-exec" {
    command = <<EOT
              docker login ${local.ecr_url} \
              --username ${local.ecr_token.user_name} \
              --password ${local.ecr_token.password}
              EOT
  }
}

resource "terraform_data" "build" {
  depends_on = [terraform_data.login]
  provisioner "local-exec" {
    command = <<EOT
              docker build -t ${local.ecr_url} \
              ${path.module}/apps/${var.app_path}
              EOT 
  }
}
