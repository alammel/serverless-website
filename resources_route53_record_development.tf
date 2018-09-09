/*********************************************************************\
 *
 * Route 53 Record for this Terraform Project
 *
\*********************************************************************/

resource "aws_route53_record" "website-dns-record-development-main" {
  provider = "aws.local"
  zone_id  = "${local.route53_zone_id}"
  name     = "${local.website_domain_development}."
  type     = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.web-development.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.web-development.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website-dns-record-development-alias" {
  provider = "aws.local"
  count    = "${length(local.website_aliases_development)}"
  zone_id  = "${local.route53_zone_id}"
  name     = "${local.website_aliases_development[count.index]}."
  type     = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.web-development.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.web-development.hosted_zone_id}"
    evaluate_target_health = false
  }
}

### EOF

