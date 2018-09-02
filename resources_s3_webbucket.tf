/*********************************************************************\
 *
 * Web Bucket for this Terraform Project
 *
\*********************************************************************/

###
### Web Bucket
###

resource "aws_s3_bucket" "web-bucket" {
  provider = "aws.local"
  bucket   = "${local.name_short}-web"
  acl      = "bucket-owner-full-control"

  tags = "${merge(
    local.tags,
    map(
      "Name", "${local.name_short}-web",
      "Function", "web-bucket",
    ))}"
}

###
### Web Bucket Policy
###


### EOF

