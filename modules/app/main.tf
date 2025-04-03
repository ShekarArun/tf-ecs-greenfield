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

resource "terraform_data" "push" {
  depends_on = [
    terraform_data.login,
    terraform_data.build
  ]
  triggers_replace = [
    var.image_version
  ]

  provisioner "local-exec" {
    command = <<EOT
              docker image tag ${local.ecr_url} \
              ${local.ecr_url}:${var.image_version}
              docker image tag ${local.ecr_url} \
              ${local.ecr_url}:latest
              docker image push ${local.ecr_url}:${var.image_version}
              docker image push ${local.ecr_url}:latest
              EOT 
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.app_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_execution_role_arn
  container_definitions = jsonencode([
    {
      name      = var.app_name
      image     = "${local.ecr_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.port
          hostPort      = var.port
        }
      ]
    }
  ])
}
