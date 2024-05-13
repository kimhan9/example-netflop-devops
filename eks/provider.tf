provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-0235"
    key    = "netflop-eks/terraform.tfstate"
    region = "ap-southeast-1"
  }
}