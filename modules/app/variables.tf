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

variable "ecs_cluster_id" {
  description = "ID of the ECS Cluster to be allocated to the service"
  type        = string
  # TODO: Expand to regex match of ID
}

variable "subnet_ids" {
  description = "Subnets to associate the ECS Service"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group for the ECS Service to be associated to"
  type        = string
}

variable "is_public" {
  description = "Is the ECS Service assigned a public IP?"
  type        = bool
}
