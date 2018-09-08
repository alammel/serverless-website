/*********************************************************************\
 *
 * ECR Repository for this Terraform Project
 *
\*********************************************************************/

###
### ECR Repository
###

resource "aws_ecr_repository" "codebuild" {
  provider = "aws.local"
  name     = "${local.name_short}"
}

###
### ECR Repository Access Policy Object for CodeBuild
###

resource "aws_ecr_repository_policy" "codebuild" {
  provider   = "aws.local"
  repository = "${aws_ecr_repository.codebuild.name}"
  policy     = "${data.aws_iam_policy_document.codebuild-ecr-access.json}"
}

###
### ECR Repository Access Policy Document for CodeBuild
###

data "aws_iam_policy_document" "codebuild-ecr-access" {
  provider = "aws.local"

  statement {
    sid = "AllowCodeBuildUseImage"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]

    principals {
      type = "Service"

      identifiers = [
        "codebuild.amazonaws.com",
      ]
    }
  }
}

### EOF

