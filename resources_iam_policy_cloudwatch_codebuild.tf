/*********************************************************************\
 *
 * IAM CloudWatch Policy for this Terraform Project
 *
\*********************************************************************/

###
### Create IAM policy document
###

data "aws_iam_policy_document" "cloudwatch" {
  provider = "aws.local"

  statement {
    sid = "AllowStartPipelineExecution"

    actions = [
      "codepipeline:StartPipelineExecution",
    ]

    resources = [
      "${aws_codepipeline.codepipeline.arn}",
    ]
  }
}

###
### Create IAM Policy Object
###

resource "aws_iam_role_policy" "cloudwatch" {
  provider = "aws.local"
  role     = "${aws_iam_role.cloudwatch.name}"
  policy   = "${data.aws_iam_policy_document.cloudwatch.json}"
}

### EOF

