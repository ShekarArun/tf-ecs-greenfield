locals {
  app_name = "app"
  apps = {
    ui = {
      ecr_repository_name = "ui"
      app_path            = "ui"
      image_version       = "1.0.1"
      app_name            = "ui"
      port                = 80
      is_public           = true
      path_pattern        = "/*"
      healthcheck_path    = "/*"
    }
    api = {
      ecr_repository_name = "api"
      app_path            = "api"
      image_version       = "1.0.1"
      app_name            = "api"
      port                = 80
      is_public           = true
      path_pattern        = "/*"
      healthcheck_path    = "/api/healthcheck"
    }
  }


}
