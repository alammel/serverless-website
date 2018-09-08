/*********************************************************************\
 *
 * Lambda Function request-modifier for this Terraform Project
 *
\*********************************************************************/

###
### Package Lambda Function
###

data "archive_file" "request-modifier" {
  type        = "zip"
  source_file = "${path.module}/functions/source/request-modifier.js"
  output_path = "${path.module}/functions/packaged/request-modifier.zip"
}

###
### Create Lambda Function from Package
###

resource "aws_lambda_function" "request-modifier" {
  provider = "aws.local"

  filename         = "${path.module}/functions/packaged/request-modifier.zip"
  function_name    = "request-modifier"
  role             = "${aws_iam_role.request-modifier.arn}"
  handler          = "request-modifier.handler"
  source_code_hash = "${data.archive_file.request-modifier.output_base64sha256}"
  runtime          = "nodejs8.10"
  publish          = true

  environment {
    variables = {
      codebuid_project_name = "${local.name_short}"
    }
  }
}

### EOF

