/*********************************************************************\
 *
 * Logging Bucket for this Terraform Project
 *
\*********************************************************************/

###
### Logging Bucket
###

resource "aws_s3_bucket" "logging-bucket" {
  provider = "aws.local"
  bucket   = "${local.name_short}-logging"
  acl      = "bucket-owner-full-control"

  lifecycle_rule {
    id      = "AutoExpireLogs"
    enabled = true
    prefix  = "${local.cf_logging_prefix}"

    expiration {
      days = 7
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  tags = "${merge(
    local.tags,
    map(
      "Name", "${local.name_short}-logging",
      "Function", "logging-bucket",
    ))}"
}

###
### Logging Bucket Policy Document
###

data "aws_iam_policy_document" "logging-bucket" {
  provider = "aws.local"

  statement {
    sid = "AllowReadonlyObjectAccess"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.logging-bucket.arn}/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "${aws_iam_user.development.arn}",
      ]
    }
  }

  statement {
    sid = "AllowListBucket"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.logging-bucket.arn}",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "${aws_iam_user.development.arn}",
      ]
    }
  }
}

###
### Logging Bucket Policy Object
###

resource "aws_s3_bucket_policy" "logging-bucket" {
  provider = "aws.local"
  bucket   = "${aws_s3_bucket.logging-bucket.id}"
  policy   = "${data.aws_iam_policy_document.logging-bucket.json}"
}

### EOF

