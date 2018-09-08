resource "aws_codebuild_project" "codebuild" {
  provider    = "aws.local"
  name        = "${local.name_short}"
  description = "${local.name_short}"

  build_timeout = "5"
  service_role  = "${aws_iam_role.codebuild.arn}"
  badge_enabled = true

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "${aws_ecr_repository.codebuild.repository_url}:latest"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "WEB_BUCKET_PRODUCTION"
      "value" = "${aws_s3_bucket.web-bucket.id}"
    }

    environment_variable {
      "name"  = "WEB_BUCKET_TESTING"
      "value" = "${aws_s3_bucket.web-bucket.id}"
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = "${aws_codecommit_repository.web.clone_url_http}"
    git_clone_depth = 1
  }

  tags = "${merge(
    local.tags,
    map(
      "Name", "${local.name_short}",
      "Function", "codebuild-project",
    ))}"
}

### EOF

