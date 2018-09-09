/*********************************************************************\
 *
 * Create Docker Makefile for this Terraform Project
 *
\*********************************************************************/

###
### Docker Makefile Template Object
###

data "template_file" "docker-makefile" {
  template = "${file("${path.module}/templates/docker/Makefile.tpl")}"

  vars {
    image_name  = "${local.name_short}:latest"
    image_tag   = "${aws_ecr_repository.codebuild.repository_url}:latest"
    aws_region  = "${local.aws_region}"
    aws_profile = "${local.aws_dev_profile}"
  }
}

###
### Docker Makefile Local File Object
###

resource "local_file" "docker-makefile" {
  content  = "${data.template_file.docker-makefile.rendered}"
  filename = "${path.module}/docker/Makefile"
}

###
###
###

