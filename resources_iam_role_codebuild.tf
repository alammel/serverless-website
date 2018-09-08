/*********************************************************************\
 *
 * CodeBuild IAM Role for this Terraform Project
 *
\*********************************************************************/

###
### IAM Role for CodeBuild
###

resource "aws_iam_role" "codebuild" {
  provider           = "aws.local"
  name               = "${local.name_short}-codebuild"
  assume_role_policy = "${data.aws_iam_policy_document.codebuild-assume-role.json}"
}

###
### IAM Assume Role Policy Document for CodeBuild
###

data "aws_iam_policy_document" "codebuild-assume-role" {
  provider = "aws.local"

  statement {
    sid = "AllowSTSAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "codebuild.amazonaws.com",
      ]
    }
  }
}

### EOF

