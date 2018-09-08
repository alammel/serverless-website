/*********************************************************************\
 *
 * CodeBuild IAM Role for this Terraform Project
 *
\*********************************************************************/

###
### IAM Policy Object for CodeBuild
###

data "aws_iam_policy_document" "codebuild" {
  provider = "aws.local"

  statement {
    sid = "AllowCloudWatchLogs"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "AllowElasticCompute"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "AllowCodeCommitAccess"

    actions = [
      "codecommit:GitPull",
      "codecommit:GitPush",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:UploadArchive",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:CancelUploadArchive",
    ]

    resources = [
      "${aws_codecommit_repository.web.arn}",
      "${aws_codecommit_repository.web.arn}/*",
    ]
  }

  statement {
    sid = "AllowS3Upload"

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.web-bucket.arn}",
      "${aws_s3_bucket.web-bucket.arn}/*",
    ]
  }

  statement {
    sid = "AllowCreateInvalidation"

    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetDistribution",
      "cloudfront:GetStreamingDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations",
      "cloudfront:ListStreamingDistributions",
      "cloudfront:ListDistributions",
    ]

    resources = [
      "*",
    ]
  }
}

###
### Create IAM Policy Object
###

resource "aws_iam_policy" "codebuild" {
  provider = "aws.local"
  name     = "${aws_iam_role.codebuild.name}"
  policy   = "${data.aws_iam_policy_document.codebuild.json}"
}

### EOF

