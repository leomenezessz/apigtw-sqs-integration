provider "aws" {
  region                  = var.region
  shared_credentials_file = var.credentials
  profile                 = var.profile
}

terraform {
  backend "s3" {
    bucket = "terraform-state-leomenezessz"
    key    = "tf-state/terraform.tfstate"
    region = "us-east-1"
  }
}