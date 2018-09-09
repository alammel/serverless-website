/*********************************************************************\
 *
 * Route 53 Record for this Terraform Project
 *
\*********************************************************************/

###
### Create ACM certificate
###

resource "aws_acm_certificate" "website-certificate-production" {
  provider                  = "aws.cloudfront"
  domain_name               = "${local.website_domain_production}"
  subject_alternative_names = ["${local.website_aliases_production}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = "${merge(
    local.tags,
    map(
      "Name", "${local.website_domain_production}",
      "Function", "acm-certificate-production",
  ))}"
}

###
### Create ACM certificate validation
###

resource "aws_acm_certificate_validation" "website-certificate-production" {
  provider                = "aws.cloudfront"
  certificate_arn         = "${aws_acm_certificate.website-certificate-production.arn}"
  validation_record_fqdns = ["${aws_route53_record.website-certificate-production-validation.*.fqdn}"]
}

###
### Create ACM certificate validation DNS records
###

resource "aws_route53_record" "website-certificate-production-validation" {
  provider = "aws.cloudfront"
  count    = "${length(local.website_aliases_production)+1}"
  name     = "${lookup(aws_acm_certificate.website-certificate-production.domain_validation_options[count.index], "resource_record_name")}"
  type     = "${lookup(aws_acm_certificate.website-certificate-production.domain_validation_options[count.index], "resource_record_type")}"
  zone_id  = "${local.route53_zone_id}"
  records  = ["${lookup(aws_acm_certificate.website-certificate-production.domain_validation_options[count.index], "resource_record_value")}"]
  ttl      = 60
}

### EOF

