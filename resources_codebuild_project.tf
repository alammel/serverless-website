resource "aws_codebuild_project" "example" {
  name         = "${local.name_short}"
  description  = "${local.name_short"
  build_timeout      = "5"
  service_role = "${aws_iam_role.codebuild.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "${aws_ecr_repository.codebuild.repository_url}:latest"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "WEB_BUCKET_PRODUCTION"
      "value" = "${aws_s3_bucket.web-bucket.name}"
    }

    environment_variable {
      "name"  = "WEB_BUCKET_TESTING"
      "value" = "${aws_s3_bucket.web-bucket.name}"
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = "${aws_codecommit_repository.arn}"
    git_clone_depth = 1
  }

  tags = "${merge(
    local.tags,
    map(
      "Name", "${local.name_short}",
      "Function", "codebuild-project",
    ))}"
}