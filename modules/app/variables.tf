variable "ecr_repo_name" {
  description = "The ECR Repo name"
  type        = string
}

variable "app_path" {
  description = "The path to the app for which a Docker container is to be built"
  type        = string
}

variable "image_version" {
  description = "The version of the image to be tagged to the built container"
  type        = string
}

variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "port" {
  description = "Port number for the container task"
  type        = number
}

variable "ecs_execution_role_arn" {
  description = "ARN of the ECS Execution Role"
  type        = string
}
