/*********************************************************************\
 *
 * Terraform CodeCommit Repository for this Terraform Project
 *
\*********************************************************************/

resource "aws_codecommit_repository" "terraform" {
  provider        = "aws.local"
  repository_name = "${local.name_short}-terraform"
  description     = "Terraform infrastructure development"
}

### EOF

