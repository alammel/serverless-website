/*********************************************************************\
 *
 * IAM Development Group for this Terraform Project
 *
\*********************************************************************/

###
### Create Development IAM Group
###

resource "aws_iam_group" "development" {
  provider = "aws.local"
  name     = "${local.name_short}-development"
  path     = "/users/"
}

###
### Attach Development IAM Policy
###

resource "aws_iam_group_policy_attachment" "development" {
  provider   = "aws.local"
  group      = "${aws_iam_group.development.name}"
  policy_arn = "${aws_iam_policy.development.arn}"
}

### EOF

