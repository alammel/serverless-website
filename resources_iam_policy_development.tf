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

