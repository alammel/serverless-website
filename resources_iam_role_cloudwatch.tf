/*********************************************************************\
 *
 * Lambda Function cloudwatch IAM Role for this Terraform Project
 *
\*********************************************************************/

###
### IAM Assume Role Policy Document for cloudwatch
###

data "aws_iam_policy_document" "cloudwatch-assume-role" {
  provider = "aws.local"

  statement {
    sid = "AllowSTSAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "events.amazonaws.com",
      ]
    }
  }
}

###
### IAM Role for cloudwatch
###

resource "aws_iam_role" "cloudwatch" {
  provider           = "aws.local"
  name               = "${local.name_short}-cloudwatch"
  assume_role_policy = "${data.aws_iam_policy_document.cloudwatch-assume-role.json}"
}

### EOF

