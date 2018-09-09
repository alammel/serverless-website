/*********************************************************************\
 *
 * Lookups for this Terraform Project
 *
\*********************************************************************/

data "aws_route53_zone" "website_domain" {
  provider     = "aws.local"
  name         = "${local.website_domain}."
  private_zone = false
}

### EOF

