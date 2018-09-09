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
  aws_dev_profile = "${var.aws_dev_profile}"
  backend_bucket  = "${var.backend_bucket}"

  ###
  ### Resource Naming Scheme
  ###

  path_short = "${local.project}/${local.environment}/${local.component}"
  name_short = "${local.project}-${local.environment}-${local.component}"

  ###
  ### Route 53 configuration
  ###

  route53_zone_id = "${data.aws_route53_zone.website_domain.zone_id}"

  ###
  ### CloudFront configuration
  ###

  cf_price_class         = "PriceClass_All"
  cf_region_main         = "us-east-1"
  cf_logging_prefix      = "web/"
  cf_default_index       = "index.html"
  cf_comment_production  = "Production website for domain ${local.website_domain}"
  cf_comment_development = "Development website for domain ${local.website_domain}"

  ###
  ### Website Domains conficuration
  ###

  website_domain_production = "www.${local.website_domain}"
  website_url_production    = "https://${local.website_domain_production}"
  website_aliases_production = [
    "${local.website_domain}",
  ]
  website_domain_development = "www.dev.${local.website_domain}"
  website_url_development    = "https://${local.website_domain_development}"
  website_aliases_development = [
    "dev.${local.website_domain}",
  ]

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

