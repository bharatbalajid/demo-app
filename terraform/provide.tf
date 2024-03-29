terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.58.0"
    }
  }
}
provider "aws" {
  # profile = "default"
  region  = var.region
}
terraform {
  backend "s3" {
    bucket = "test-app-ga"
    key    = "./terraform.tfstate"
    region = "us-east-1"
  }
}
