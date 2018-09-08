/*********************************************************************\
 *
 * IAM codepipeline Policy for this Terraform Project
 *
\*********************************************************************/

###
### Create IAM policy document
###

data "aws_iam_policy_document" "codepipeline" {
  provider = "aws.local"

  statement {
    sid = "AllowS3AccessAny"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "AllowS3AccessPipeline"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::codepipeline*",
      "arn:aws:s3:::elasticbeanstalk*",
    ]
  }

  statement {
    sid = "AllowCodeCommitAccess"

    actions = [
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "AllowCodeDeployAccess"

    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "AllowMultipleAccess"

    actions = [
      "elasticbeanstalk:*",
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "codepipeline:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:*",
      "iam:PassRole",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "AllowLambdaAccess"

    actions = [
      "lambda:InvokeFunction",
      "lambda:ListFunctions",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "AllowOpsWorksAccess"

    actions = [
      "opsworks:CreateDeployment",
      "opsworks:DescribeApps",
      "opsworks:DescribeCommands",
      "opsworks:DescribeDeployments",
      "opsworks:DescribeInstances",
      "opsworks:DescribeStacks",
      "opsworks:UpdateApp",
      "opsworks:UpdateStack",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "AllowCloudFormationAccess"

    actions = [
      "cloudformation:CreateStack",
      "cloudformation:DeleteStack",
      "cloudformation:DescribeStacks",
      "cloudformation:UpdateStack",
      "cloudformation:CreateChangeSet",
      "cloudformation:DeleteChangeSet",
      "cloudformation:DescribeChangeSet",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:SetStackPolicy",
      "cloudformation:ValidateTemplate",
      "iam:PassRole",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "AllowCodeBuildAccess"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "AllowDeviceFarmAccess"

    actions = [
      "devicefarm:ListProjects",
      "devicefarm:ListDevicePools",
      "devicefarm:GetRun",
      "devicefarm:GetUpload",
      "devicefarm:CreateUpload",
      "devicefarm:ScheduleRun",
    ]

    resources = [
      "*",
    ]
  }
}

###
### Create IAM Policy Object
###

resource "aws_iam_policy" "codepipeline" {
  provider = "aws.local"
  name     = "${aws_iam_role.codepipeline.name}"
  policy   = "${data.aws_iam_policy_document.codepipeline.json}"
}

### EOF

