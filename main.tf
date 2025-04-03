module "budget" {
  source = "./modules/budget"
}

module "infra" {
  source   = "./modules/infra"
  vpc_cidr = "10.0.0.0/16"
}
