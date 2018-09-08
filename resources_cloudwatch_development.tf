/*********************************************************************\
 *
 * CloudWatch Event Trigger for this Terraform Project
 *
\*********************************************************************/

resource "aws_cloudwatch_event_rule" "cloudwatch-development" {
  provider    = "aws.local"
  name        = "${local.name_short}-cloudwatch-development"
  description = "Trigger CodePipeline"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codecommit"
  ],
  "detail-type": [
    "CodeCommit Repository State Change"
  ],
  "resources": [
    "${aws_codecommit_repository.web.arn}"
  ],
  "detail": {
    "event": [
      "referenceCreated",
      "referenceUpdated"
    ],
    "referenceType": [
      "branch"
    ],
    "referenceName": [
      "development"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "cloudwatch-development" {
  provider  = "aws.local"
  rule      = "${aws_cloudwatch_event_rule.cloudwatch-development.name}"
  target_id = "TrigerCodePipeline"
  role_arn  = "${aws_iam_role.cloudwatch.arn}"
  arn       = "${aws_codepipeline.codepipeline-development.arn}"
}

### EOF

