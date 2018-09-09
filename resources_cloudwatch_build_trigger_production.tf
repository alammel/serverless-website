/*********************************************************************\
 *
 * CloudWatch Event Trigger for this Terraform Project
 *
\*********************************************************************/

resource "aws_cloudwatch_event_rule" "cloudwatch-production" {
  provider    = "aws.local"
  name        = "${local.name_short}-cloudwatch-production"
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
      "master"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "cloudwatch-production" {
  provider  = "aws.local"
  rule      = "${aws_cloudwatch_event_rule.cloudwatch-production.name}"
  target_id = "TriggerCodePipeline"
  role_arn  = "${aws_iam_role.cloudwatch.arn}"
  arn       = "${aws_codepipeline.codepipeline-production.arn}"
}

### EOF

