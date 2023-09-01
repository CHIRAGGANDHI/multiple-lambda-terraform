terraform {
  required_version = "~> 1.5"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }      
  }  

  backend "s3" {
  }
}

#provider block
provider "aws" {
  region = var.aws_region
  access_key = var.aws_accesskey
  secret_key = var.aws_secret_key
}