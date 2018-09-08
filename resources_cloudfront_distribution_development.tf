/*********************************************************************\
 *
 * CloudFront Distribution for this Terraform Project
 *
\*********************************************************************/

###
### Create Access Identity
###

resource "aws_cloudfront_origin_access_identity" "web-development" {
  provider = "aws.local"
  comment  = "Access Identity to be used in bucket policy"
}

###
### Create CloudFront Distribution
###

resource "aws_cloudfront_distribution" "web-development" {
  provider = "aws.local"

  origin {
    domain_name = "${aws_s3_bucket.web-bucket-development.bucket_regional_domain_name}"
    origin_id   = "${aws_cloudfront_origin_access_identity.web-development.id}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.web-development.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${local.cf_comment_development}"
  default_root_object = "${local.cf_default_index}"

  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.logging-bucket.bucket_domain_name}"
    prefix          = "${local.cf_logging_prefix}development/"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  aliases = "${local.cloudfront_aliases_development}"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_cloudfront_origin_access_identity.web-development.id}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = "${aws_lambda_function.request-modifier.qualified_arn}"
    }
  }

  price_class = "${local.cloudfront_price_class}"
  tags        = "${local.tags}"

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

### EOF

