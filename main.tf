module "budget" {
  source            = "./modules/budget"
  budget_name       = "budget_monthly"
  budget_limit      = "10.0"
  budget_email_list = ["shekar.arun+tf-ecs-greenfield@gmail.com"]
}

module "infra" {
  source      = "./modules/infra"
  vpc_cidr    = "10.0.0.0/16"
  num_subnets = 4
  allowed_ips = ["0.0.0.0/0"]
  app_name    = local.app_name
}

module "app" {
  source                 = "./modules/app"
  ecr_repo_name          = "ui"
  app_path               = "ui"
  image_version          = "1.0.1"
  app_name               = local.app_name
  port                   = 80
  ecs_execution_role_arn = module.infra.ecs_execution_role_arn
  ecs_cluster_id         = module.infra.ecs_cluster_details.id
  # Cannot have load balancer with multiple subnets in the same availability zone
  # So, extract a list of the first subnet ID from each AZ
  subnet_ids = [
    for az, id in {
      for subnet in module.infra.subnet_details : subnet.az => subnet.id... # The ellipsis groups by the key (AZ in this case)
    } : id[0]                                                               # Extract first item in each AZ since it is now grouped by AZ
  ]
  security_group_id = module.infra.app_sg_details.sg_id
  is_public         = true # Needed in our case because only then, the service can access ECR
  vpc_id            = module.infra.vpc_details.id
  alb_listener_arn  = module.infra.alb_details.alb_listener_arn
  path_pattern      = "/*"
}
