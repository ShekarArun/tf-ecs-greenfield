terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
  default_tags {
    tags = {
      iac     = "true"
      project = "tf-ecs-greenfield"
    }
  }
}
