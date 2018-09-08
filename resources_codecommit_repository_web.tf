/*********************************************************************\
 *
 * Web CodeCommit Repository for this Terraform Project
 *
\*********************************************************************/

resource "aws_codecommit_repository" "web" {
  provider        = "aws.local"
  repository_name = "${local.name_short}-web"
  description     = "Web page development"
}

### EOF

