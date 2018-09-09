/*********************************************************************\
 *
 * Route 53 Record for this Terraform Project
 *
\*********************************************************************/

resource "aws_route53_record" "website-dns-record-production-main" {
  provider = "aws.local"
  zone_id  = "${local.route53_zone_id}"
  name     = "${local.website_domain_production}."
  type     = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.web-production.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.web-production.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website-dns-record-production-alias" {
  provider = "aws.local"
  count    = "${length(local.website_aliases_production)}"
  zone_id  = "${local.route53_zone_id}"
  name     = "${local.website_aliases_production[count.index]}."
  type     = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.web-production.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.web-production.hosted_zone_id}"
    evaluate_target_health = false
  }
}

### EOF

