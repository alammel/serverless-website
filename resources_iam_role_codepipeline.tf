/*********************************************************************\
 *
 * Lambda Function codepipeline IAM Role for this Terraform Project
 *
\*********************************************************************/

###
### IAM Role for codepipeline
###

resource "aws_iam_role" "codepipeline" {
  provider           = "aws.local"
  name               = "${local.name_short}-codepipeline"
  assume_role_policy = "${data.aws_iam_policy_document.codepipeline-assume-role.json}"
}

###
### IAM Assume Role Policy Document for codepipeline
###

data "aws_iam_policy_document" "codepipeline-assume-role" {
  provider = "aws.local"

  statement {
    sid = "AllowSTSAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "codepipeline.amazonaws.com",
      ]
    }
  }
}

### EOF

