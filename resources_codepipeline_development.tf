/*********************************************************************\
 *
 * CodePipeline for this Terraform Project
 *
\*********************************************************************/

resource "aws_codepipeline" "codepipeline-development" {
  provider = "aws.local"
  name     = "${local.name_short}-codepipeline-development"
  role_arn = "${aws_iam_role.codepipeline.arn}"

  artifact_store {
    location = "${aws_s3_bucket.web-bucket-development.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      input_artifacts  = []
      output_artifacts = ["${local.name_short}"]
      version          = 1
      run_order        = 1

      configuration {
        PollForSourceChanges = false
        RepositoryName       = "${aws_codecommit_repository.web.repository_name}"
        BranchName           = "development"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["${local.name_short}"]
      output_artifacts = []
      version          = "1"
      run_order        = 1

      configuration {
        ProjectName = "${aws_codebuild_project.codebuild-development.name}"
      }
    }
  }
}

###
### EOF
###

