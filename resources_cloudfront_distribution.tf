/*********************************************************************\
 *
 * CloudFront Distribution for this Terraform Project
 *
\*********************************************************************/

###
### Create Access Identity
###

resource "aws_cloudfront_origin_access_identity" "web" {
  provider = "aws.local"
  comment  = "Access Identity to be used in bucket policy"
}

###
### Create CloudFront Distribution
###

resource "aws_cloudfront_distribution" "web" {
  provider = "aws.local"

  origin {
    domain_name = "${aws_s3_bucket.web-bucket.bucket_regional_domain_name}"
    origin_id   = "${aws_cloudfront_origin_access_identity.web.id}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.web.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "noitect.de"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.logging-bucket.bucket_domain_name}"
    prefix          = "blog/"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  aliases = [
    "noitect.de",
    "www.noitect.de",
    "blog.noitect.de",
  ]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_cloudfront_origin_access_identity.web.id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"
  tags        = "${local.tags}"

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

### EOF

