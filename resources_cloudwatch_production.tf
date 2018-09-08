/*********************************************************************\
 *
 * CloudWatch Event Trigger for this Terraform Project
 *
\*********************************************************************/

resource "aws_cloudwatch_event_rule" "cloudwatch" {
  provider    = "aws.local"
  name        = "${local.name_short}-codepipeline"
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

resource "aws_cloudwatch_event_target" "cloudwatch" {
  provider  = "aws.local"
  rule      = "${aws_cloudwatch_event_rule.cloudwatch.name}"
  target_id = "TrigerCodePipeline"
  role_arn  = "${aws_iam_role.cloudwatch.arn}"
  arn       = "${aws_codepipeline.codepipeline.arn}"
}

### EOF

