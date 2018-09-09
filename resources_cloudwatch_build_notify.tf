/*********************************************************************\
 *
 * CloudWatch Event Trigger for this Terraform Project
 *
\*********************************************************************/

resource "aws_cloudwatch_event_rule" "notification-development" {
  provider    = "aws.local"
  name        = "${local.name_short}-notification-development"
  description = "Trigger CodePipeline"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codepipeline"
  ],
  "detail-type": [
    "CodePipeline Pipeline Execution State Change"
  ],
  "detail": {
    "state": [
      "STARTED",
      "SUCCEEDED",
      "FAILED"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "notification-development" {
  provider  = "aws.local"
  rule      = "${aws_cloudwatch_event_rule.notification-development.name}"
  target_id = "NotifyCodePipelineStatusChange"
  arn       = "${aws_sns_topic.notification.arn}"

  input_transformer {
    input_paths = {
      pipeline = "$.detail.pipeline"
      state    = "$.detail.state"
    }

    input_template = "\"The Pipeline <pipeline> is now in <state> state.\""
  }
}

### EOF

