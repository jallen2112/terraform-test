terraform {
  backend "local" {}
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_s3_bucket" "terraform-bucket-test" {
  bucket = var.name
  acl    = var.access
  versioning {
    enabled = true
  }
}
