#!/bin/bash

###
### Static configuration
###

CONFIG_FILE="terraform.tfvars"
OUTPUT_FILE="statefile.tf"

###
### Parse configuration file
###

AWS_ACCTID="$(cat ${CONFIG_FILE} | grep aws_account_id  | awk -F '=' '{print $2}' | sed 's/^\s*//g; s/\s*$//g; s/\"*//g')"
AWS_REGION="$(cat ${CONFIG_FILE} | grep aws_region      | awk -F '=' '{print $2}' | sed 's/^\s*//g; s/\s*$//g; s/\"*//g')"
AWS_PROFLE="$(cat ${CONFIG_FILE} | grep aws_profile     | awk -F '=' '{print $2}' | sed 's/^\s*//g; s/\s*$//g; s/\"*//g')"
PROJECT_ID="$(cat ${CONFIG_FILE} | grep project         | awk -F '=' '{print $2}' | sed 's/^\s*//g; s/\s*$//g; s/\"*//g')"
PCOMPONENT="$(cat ${CONFIG_FILE} | grep component       | awk -F '=' '{print $2}' | sed 's/^\s*//g; s/\s*$//g; s/\"*//g')"
ENVIRONMEN="$(cat ${CONFIG_FILE} | grep environment     | awk -F '=' '{print $2}' | sed 's/^\s*//g; s/\s*$//g; s/\"*//g')"
PCREDSFILE="$(cat ${CONFIG_FILE} | grep credential_file | awk -F '=' '{print $2}' | sed 's/^\s*//g; s/\s*$//g; s/\"*//g')"
BACKENDBKT="$(cat ${CONFIG_FILE} | grep backend_bucket  | awk -F '=' '{print $2}' | sed 's/^\s*//g; s/\s*$//g; s/\"*//g')"

###
### Report data parsed from configuration
###

echo "Using configuration  : ${CONFIG_FILE}"
echo "Using aws_account_id : ${AWS_ACCTID}"
echo "Using aws_region     : ${AWS_REGION}"
echo "Using aws_profile    : ${AWS_PROFLE}"
echo "Using project        : ${PROJECT_ID}"
echo "Using component      : ${PCOMPONENT}"
echo "Using environment    : ${ENVIRONMEN}"
echo "Using credential_file: ${PCREDSFILE}"
echo "Using backend_bucket : ${BACKENDBKT}"
echo "Using backend config : ${OUTPUT_FILE}"

###
### Write Terraform backend configuration
###

cat > "${OUTPUT_FILE}" <<BACKENDCONFIG 
/*********************************************************************\\
 *
 * Backend Configuration for this Terraform Project
 *
\\*********************************************************************/

terraform {
  backend "s3" {
    profile = "${AWS_PROFLE}"

    shared_credentials_file = "${PCREDSFILE}"

    role_arn     = "arn:aws:iam::${AWS_ACCTID}:role/service.terraform"
    session_name = "backend"

    encrypt = true
    bucket  = "${BACKENDBKT}"
    region  = "${AWS_REGION}"
    key     = "${PROJECT_ID}/${ENVIRONMEN}/${PCOMPONENT}/terraform.tfstate"
  }
}

### EOF

BACKENDCONFIG

### EOF
