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
      "${aws_codepipeline.codepipeline-production.arn}",
      "${aws_codepipeline.codepipeline-development.arn}",
    ]
  }
}

###
### Create IAM Policy Object
###

resource "aws_iam_policy" "cloudwatch" {
  provider = "aws.local"
  name     = "${aws_iam_role.cloudwatch.name}"
  policy   = "${data.aws_iam_policy_document.cloudwatch.json}"
}

###
### Attach IAM Policy Object
###

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  provider   = "aws.local"
  role       = "${aws_iam_role.cloudwatch.name}"
  policy_arn = "${aws_iam_policy.cloudwatch.arn}"
}

### EOF

