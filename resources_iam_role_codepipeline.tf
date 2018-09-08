/*********************************************************************\
 *
 * Lambda Function codepipeline IAM Role for this Terraform Project
 *
\*********************************************************************/

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

###
### IAM Role for codepipeline
###

resource "aws_iam_role" "codepipeline" {
  provider           = "aws.local"
  name               = "${local.name_short}-codepipeline"
  assume_role_policy = "${data.aws_iam_policy_document.codepipeline-assume-role.json}"
}

###
### Attach IAM Policy Object
###

resource "aws_iam_role_policy_attachment" "codepipeline" {
  provider   = "aws.local"
  role       = "${aws_iam_role.codepipeline.name}"
  policy_arn = "${aws_iam_policy.codepipeline.arn}"
}

### EOF

