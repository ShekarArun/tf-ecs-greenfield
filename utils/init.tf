# IMPORTANT:
# Run only this TF code when initializing the project
# This is so that the relevant S3 bucket can be created for the remote backend
# Subsequently, configure the bucket into the actual project for future state management through S3

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Or your desired version
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  default_tags {
    tags = {
      iac     = "true"
      project = "tf-ecs-greenfield"
    }
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "tf-ecs-greenfield-tf-backend"

  # Prevent accidental deletion
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
