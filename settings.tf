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

  aws_account_id  = "${var.aws_account_id}"
  aws_region      = "${var.aws_region}"
  aws_profile     = "${var.aws_profile}"
  project         = "${var.project}"
  environment     = "${var.environment}"
  component       = "${var.component}"
  website_domain  = "${var.website_domain}"
  credential_file = "${var.credential_file}"

  ###
  ### Resource Naming Scheme
  ###

  path_short = "${local.project}/${local.environment}/${local.component}"
  name_short = "${local.project}-${local.environment}-${local.component}"

  ###
  ### CloudFront configuration
  ###

  cf_region_main        = "us-east-1"
  cf_logging_prefix     = "web/"
  cf_default_index      = "index.html"
  cf_comment_production = "Production website for domain ${local.website_domain}"
  cf_website_production = "https://www.${local.website_domain}"
  cloudfront_aliases_production = [
    "${local.website_domain}",
    "www.${local.website_domain}",
  ]
  cf_comment_development = "Development website for domain ${local.website_domain}"
  cf_website_development = "https://www.dev.${local.website_domain}"
  cloudfront_aliases_development = [
    "dev.${local.website_domain}",
    "www.dev.${local.website_domain}",
  ]
  cloudfront_price_class = "PriceClass_All"

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

