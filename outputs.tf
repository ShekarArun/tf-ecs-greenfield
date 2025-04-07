output "budget_monthly_details" {
  value = module.budget.budget_monthly_details
}

output "infra_vpc_details" {
  value = module.infra.vpc_details
}

output "infra_igw_details" {
  value = module.infra.igw_details
}

output "infra_subnet_details" {
  value = module.infra.subnet_details
}

output "infra_alb_details" {
  value = module.infra.alb_details
}

output "infra_app_sg_details" {
  value = module.infra.app_sg_details
}

output "infra_ecs_cluster_details" {
  value = module.infra.ecs_cluster_details
}

output "app_details" {
  value = module.app
}
