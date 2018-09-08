/*********************************************************************\
 *
 * Web Bucket for this Terraform Project
 *
\*********************************************************************/

###
### Web Bucket
###

resource "aws_s3_bucket" "web-bucket-development" {
  provider = "aws.local"
  bucket   = "${local.name_short}-development"
  acl      = "bucket-owner-full-control"

  tags = "${merge(
    local.tags,
    map(
      "Name", "${local.name_short}-development",
      "Function", "web-bucket-development",
    ))}"
}

###
### Web Bucket Test Object
###

/*
resource "aws_s3_bucket_object" "web-bucket-development-test" {
  provider     = "aws.local"
  bucket       = "${aws_s3_bucket.web-bucket-development.id}"
  key          = "test.html"
  content      = "${file("${path.module}/files/test.html")}"
  content_type = "text/html"
}
*/

###
### Web Bucket Policy Document
###

data "aws_iam_policy_document" "web-bucket-development" {
  provider = "aws.local"

  statement {
    sid = "AllowReadonlyObjectAccess"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.web-bucket-development.arn}/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "${aws_iam_user.development.arn}",
        "${aws_cloudfront_origin_access_identity.web-development.iam_arn}",
      ]
    }
  }

  statement {
    sid = "AllowListBucket"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.web-bucket-development.arn}",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "${aws_iam_user.development.arn}",
        "${aws_cloudfront_origin_access_identity.web-development.iam_arn}",
      ]
    }
  }
}

###
### Web Bucket Policy Object
###

resource "aws_s3_bucket_policy" "web-bucket-development" {
  provider = "aws.local"
  bucket   = "${aws_s3_bucket.web-bucket-development.id}"
  policy   = "${data.aws_iam_policy_document.web-bucket-development.json}"
}

### EOF

