provider "aws" {
  region = "us-east-1"
}

resource "aws_codebuild_project" "codebuild_project" {
  for_each = var.pipelines

  name          = "${var.product_name}-${each.value.sourcerepo}"
  description   = "terraform_codebuild_project"
  build_timeout = "5"
  service_role  = var.codebuild_role

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    type                        = "LINUX_CONTAINER"
  }

  artifacts {
    type = "S3"
    location = var.s3_bucket
  }

  source {
    type            = var.source_type
    location        = each.value.sourcelocation
    git_clone_depth = 1

    git_submodules_config {
        fetch_submodules = true
    }
  }

  source_version = each.value.sourcebranch

  tags = {
    Product = var.product_name
  }
}

resource "aws_codepipeline" "codepipeline" {
  for_each = var.pipelines

  name     = "${var.product_name}-${each.value.sourcerepo}"
  role_arn = var.codepipeline_role

  artifact_store {
    location = var.s3_bucket
    type     = "S3"

  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = each.value.sourcerepo
        BranchName     = each.value.sourcebranch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.codebuild_project[each.key].id}"
      }
    }
  }
}
