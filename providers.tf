/*********************************************************************\
 *
 * Providers for this Terraform Project
 *
\*********************************************************************/

###
### Default AWS Provider
###

provider "aws" {
  alias   = "local"
  region  = "${local.aws_region}"
  profile = "${local.aws_profile}"

  shared_credentials_file = "${local.credential_file}"

  assume_role {
    role_arn     = "arn:aws:iam::${local.aws_account_id}:role/service.terraform"
    session_name = "${local.name_short}-local"
  }
}

###
### AWS Provider used for ACM Certificates used by CloudFront
###

provider "aws" {
  alias   = "cloudfront"
  region  = "${local.cf_region_main}"
  profile = "${local.aws_profile}"

  shared_credentials_file = "${local.credential_file}"

  assume_role {
    role_arn     = "arn:aws:iam::${local.aws_account_id}:role/service.terraform"
    session_name = "${local.name_short}-cloudfront"
  }
}

### EOF

