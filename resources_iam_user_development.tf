/*********************************************************************\
 *
 * IAM Development User for this Terraform Project
 *
\*********************************************************************/

###
### Create TLS Key
###

resource "tls_private_key" "development" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

###
### Create OpenSSH Key Pair
###

resource "aws_iam_user_ssh_key" "development" {
  provider   = "aws.local"
  username   = "${aws_iam_user.development.name}"
  encoding   = "SSH"
  public_key = "${tls_private_key.development.public_key_openssh}"
}

###
### Create Development IAM User
###

resource "aws_iam_user" "development" {
  provider = "aws.local"
  name     = "${local.name_short}-development"
  path     = "/users/"
}

###
### Make Development IAM USer member of Development IAM Group
###

resource "aws_iam_group_membership" "development" {
  provider = "aws.local"
  name     = "${local.name_short}-development"
  group    = "${aws_iam_group.development.name}"

  users = [
    "${aws_iam_user.development.name}",
  ]
}

###
### Write Secrets to the SSM Parameter Store
###

resource "aws_ssm_parameter" "development_public_key_openssh" {
  provider = "aws.local"
  name     = "/${local.path_short}/development/public_key_openssh"
  type     = "String"
  value    = "${tls_private_key.development.public_key_openssh}"
  tags     = "${local.tags}"
}

resource "aws_ssm_parameter" "development_private_key_pem" {
  provider = "aws.local"
  name     = "/${local.path_short}/development/private_key_pem"
  type     = "SecureString"
  value    = "${tls_private_key.development.private_key_pem}"
  tags     = "${local.tags}"
}

resource "aws_ssm_parameter" "development_fingerprint" {
  provider = "aws.local"
  name     = "/${local.path_short}/development/fingerprint"
  type     = "String"
  value    = "${aws_iam_user_ssh_key.development.fingerprint}"
  tags     = "${local.tags}"
}

resource "aws_ssm_parameter" "development_ssh_public_key_id" {
  provider = "aws.local"
  name     = "/${local.path_short}/development/ssh_public_key_id"
  type     = "String"
  value    = "${aws_iam_user_ssh_key.development.ssh_public_key_id}"
  tags     = "${local.tags}"
}

### EOF

