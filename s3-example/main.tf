terraform {
  backend "local" {}
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_s3_bucket" "terraform-bucket-test" {
  for_each = var.projects

  bucket = each.value.name
  acl    = each.value.access
  versioning {
    enabled = true
  }
}
