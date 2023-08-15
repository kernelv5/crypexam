terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
  profile = "kar"
  default_tags {
    tags = {
      Name  = "aws"
    }
  }
}