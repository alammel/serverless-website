/*********************************************************************\
 *
 * IAM Development Policy for this Terraform Project
 *
\*********************************************************************/

###
### Create IAM policy document
###

data "aws_iam_policy_document" "development" {
  provider = "aws.local"

  statement {
    sid = "AllowCodeCommitClonePush"

    actions = [
      "codecommit:GitPull",
      "codecommit:GitPush",
    ]

    resources = [
      "${aws_codecommit_repository.web.arn}",
      "${aws_codecommit_repository.terraform.arn}",
    ]
  }

  statement {
    sid = "AllowECRAccess"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]

    resources = [
      "${aws_ecr_repository.codebuild.arn}",
      "${aws_ecr_repository.codebuild.arn}/*",
    ]
  }

  statement {
    sid = "AllowGetECRAuthorizationToken"

    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "AllowCodeBuild"

    actions = [
      "codebuild:*",
    ]

    resources = [
      "*",
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
}

###
### Create IAM Policy Object
###

resource "aws_iam_policy" "development" {
  provider = "aws.local"
  name     = "${local.name_short}-development"
  path     = "/"
  policy   = "${data.aws_iam_policy_document.development.json}"
}

### EOF

