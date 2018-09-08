/*********************************************************************\
 *
 * IAM request-modifier Policy for this Terraform Project
 *
\*********************************************************************/

###
### Create IAM policy document
###

data "aws_iam_policy_document" "request-modifier" {
  provider = "aws.local"

  statement {
    sid = "AllowS3Upload"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

###
### Create IAM Policy Object
###

resource "aws_iam_role_policy" "request-modifier" {
  provider = "aws.local"
  role     = "${aws_iam_role.request-modifier.name}"
  policy   = "${data.aws_iam_policy_document.request-modifier.json}"
}

### EOF

