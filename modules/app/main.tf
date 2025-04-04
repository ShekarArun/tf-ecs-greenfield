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

resource "aws_ecs_service" "this" {
  name            = "${var.app_name}-ecs-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  # iam_role        = var.ecs_execution_role_arn # Cannot specify IAM role for services that require a service-linked role
  # depends_on      = [aws_iam_role_policy.foo] Not required because we're using the AWS provided role which won't be deleted, so no race condition in case of destroying resources

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = var.is_public
  }
}
