variable "pipelines" {
  type = map(object({
    sourcelocation = string
    sourcerepo = string
    sourcebranch = string
  }))
}

variable "source_type" {
  default = "CODECOMMIT"
}

variable "codebuild_role" {
}

variable "codepipeline_role" {
}

variable "product_name" {
}

variable "s3_bucket" {}
