terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.58"
    }
  }

  #   backend "remote" {
  #   organization = "yemi_test_organization"

  #   workspaces {
  #     name = "Wordpress-workspace"
  #   }
  # }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project = "AWS Terraform Project"
    }
  }
}