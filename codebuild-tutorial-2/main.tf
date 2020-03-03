provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "terraform_example" {
  name = "terraform-example"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "terraform_example" {
  role = "${aws_iam_role.terraform_example.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Resource": [
          "*"
      ],
      "Action": [
          "codecommit:GitPull"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::jordan-test-1098766",
        "arn:aws:s3:::jordan-test-1098766/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "terraform_example" {
  for_each      = toset(var.codebuild_names)

  name          = each.value
  description   = "terraform_codebuild_project"
  build_timeout = "5"
  service_role  = "${aws_iam_role.terraform_example.arn}"

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      group_name = "log-group"
      stream_name = "log-stream"
    }
  }

  artifacts {
    type = "S3"
    location = "jordan-test-1098766"
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/jordan-test"
    git_clone_depth = 1

    git_submodules_config {
        fetch_submodules = true
    }
  }

  source_version = "master"

  tags = {
    Environment = "Terraform-Test"
  }
}
