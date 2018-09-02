/*********************************************************************\
 *
 * Local Settings for this Terraform Project
 *
\*********************************************************************/

locals {
  present = true

  ###  
  ### Project Variables
  ###

  aws_account_id = "${var.aws_account_id}"
  aws_region     = "${var.aws_region}"
  project        = "${var.project}"
  environment    = "${var.environment}"
  component      = "${var.component}"

  ###
  ### Resource Naming Scheme
  ###

  path_short = "${local.project}/${local.environment}/${local.component}"
  name_short = "${local.project}-${local.environment}-${local.component}"

  ###
  ### Default Tags to set
  ###

  tags = "${map(
    "Project", "${local.project}",
    "Component", "${local.component}",
    "Environment", "${local.environment}",
  )}"
}

### EOF
