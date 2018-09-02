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
      "s3:ListObjetc",
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.logging-bucket.arn}",
      "${aws_s3_bucket.logging-bucket.arn}/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "${aws_iam_group.development.arn}",
      ]
    }
  }

  statement {
    sid = "AllowListBuckmet"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.logging-bucket.arn}",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "${aws_iam_group.development.arn}",
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

