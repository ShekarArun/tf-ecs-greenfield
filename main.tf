module "budget" {
  source            = "./modules/budget"
  budget_name       = "budget_monthly"
  budget_limit      = "10.0"
  budget_email_list = ["shekar.arun+tf-ecs-greenfield@gmail.com"]
}

module "infra" {
  source      = "./modules/infra"
  vpc_cidr    = "10.0.0.0/16"
  num_subnets = 3
  allowed_ips = ["0.0.0.0/0"]
}

module "app" {
  source                 = "./modules/app"
  ecr_repo_name          = "ui"
  app_path               = "ui"
  image_version          = "1.0.1"
  app_name               = "app"
  port                   = 80
  ecs_execution_role_arn = module.infra.ecs_execution_role_arn
}
