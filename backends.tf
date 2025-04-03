terraform {
  backend "s3" {
    bucket = "tf-ecs-greenfield-tf-backend"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
