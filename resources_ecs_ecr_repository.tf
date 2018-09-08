/*********************************************************************\
 *
 * IAM Development Group for this Terraform Project
 *
\*********************************************************************/

###
### ECR Repository
###

resource "aws_ecr_repository" "codebuild" {
  provider = "aws.local"
  name     = "${local.name_short}"
}

### EOF

