/*********************************************************************\
 *
 * Route 53 Record for this Terraform Project
 *
\*********************************************************************/

###
### Create Topic Object
###

resource "aws_sns_topic" "notification" {
  provider = "aws.local"
  name     = "${local.name_short}-notification"
}

###
### Create Topic Policy Object
###

resource "aws_sns_topic_policy" "default" {
  provider = "aws.local"
  arn      = "${aws_sns_topic.notification.arn}"
  policy   = "${data.aws_iam_policy_document.notification.json}"
}

###
### Create Topic Policy Document
###

data "aws_iam_policy_document" "notification" {
  provider = "aws.local"

  statement {
    sid = "AllowPublishToTopic"

    actions = [
      "SNS:Publish",
    ]

    resources = [
      "${aws_sns_topic.notification.arn}",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }
  }

  statement {
    sid = "AllowMultiAccessToTopic"

    actions = [
      "SNS:Publish",
      "SNS:RemovePermission",
      "SNS:SetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:Receive",
      "SNS:AddPermission",
      "SNS:Subscribe",
    ]

    resources = [
      "${aws_sns_topic.notification.arn}",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values   = ["${local.aws_account_id}"]
    }
  }
}

### EOF

