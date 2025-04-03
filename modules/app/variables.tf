variable "ecr_repo_name" {
  description = "The ECR Repo name"
  type        = string
}

variable "app_path" {
  description = "The path to the app for which a Docker container is to be built"
  type        = string
}
