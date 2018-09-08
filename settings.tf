/*********************************************************************\
 *
 * Local Settings for this Terraform Project
 *
\*********************************************************************/

locals {
  present = true

  ###  
  ### Project Variables
  ###

  aws_account_id = "${var.aws_account_id}"
  aws_region     = "${var.aws_region}"
  project        = "${var.project}"
  environment    = "${var.environment}"
  component      = "${var.component}"

  ###
  ### Resource Naming Scheme
  ###

  path_short = "${local.project}/${local.environment}/${local.component}"
  name_short = "${local.project}-${local.environment}-${local.component}"

  ###
  ### CloudFront configuration
  ###

  cloudfront_price_class = "PriceClass_All"
  cloudfront_aliases = [
    "noitect.de",
    "www.noitect.de",
    "blog.noitect.de",
  ]

  ###
  ### CloudFront Logging
  ###

  cf_logging_prefix = "blog/"
  cf_default_index  = "index.html"
  cf_comment_text   = "noitect.de"

  ###
  ### Default Tags to set
  ###

  tags = "${map(
    "Project", "${local.project}",
    "Component", "${local.component}",
    "Environment", "${local.environment}",
  )}"
}

### EOF

