resource "aws_codebuild_project" "codebuild-development" {
  provider    = "aws.local"
  name        = "${local.name_short}-development"
  description = "${local.name_short}-development"

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
      "name"  = "WEB_BUCKET_NAME"
      "value" = "${aws_s3_bucket.web-bucket-development.id}"
    }

    environment_variable {
      "name"  = "CLOUDFRONT_DISTRIBUTION"
      "value" = "${aws_cloudfront_distribution.web-development.id}"
    }

    environment_variable {
      "name"  = "WEBSITE_URL"
      "value" = "${local.cf_website_development}"
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
      "Name", "${local.name_short}-development",
      "Function", "codebuild-project",
    ))}"
}

### EOF

