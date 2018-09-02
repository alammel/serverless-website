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

### EOF

