output "codebuild_role_arn" {
  value = "${aws_iam_role.codebuild_terraform_example.arn}"
}

output "codepipeline_role_arn" {
  value = "${aws_iam_role.codepipeline_role.arn}"
}
