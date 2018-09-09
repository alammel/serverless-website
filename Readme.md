# Prerequisites for Build #

To successfully run this Terraform Project, please follow the instructions below.

The assumption is that you have already been working with Terraform and understand how it works. The same goes for all things AWS.

Please be aware that this Terraform build might change existing infrastructure in your AWS account and that I will take absolutely no liability or responsibility for any damages or issues caused by running this build.

Be warned and have fun!

## Resources and Tools ##

* AWS Account
* Internet Access
* Route 53 Domain
* Terraform IAM User
* S3 Bucket for Terraform State File
* Computer running Bash, Docker, GNU Make, Git, Terraform, AWS CLI and Hugo
* Optional: Visual Studio Code (with Terraform, Gitlens and Docker Extensions)

### Remarks on Terraform IAM User ###

* Create an IAM User  `service.terraform`
* Create an IAM Group `service.terraform`
* Create an IAM Role  `service.terraform`
* The IAM User has no permissions at all
* The IAM User is member of the IAM Group
* The IAM Group has only permission to assume the IAM Role
* The IAM Role has the AWS managed AdministratorAccess Policy assigned
* Configure the AWS Access Credentials into the Terraform Credentials Profile you plan to use 

### Remarks on Terraform Backend Bucket ###

* Make sure to enable encryption (AWS KMS with the default key)
* Make sure to enable versioning allowing you to recover your state after accidents (they WILL happen)
* Make sure to put the Bucket into the same AWS Region you plan to use in `terraform.tfvars`

### Remarks on Project Website Domain ###

* Please make sure you have your Project Website Domain in Route 53
* Please make sure that DNS for your Domain is delegated to Route 53
* Please be informed that this build will create DNS validation records for ACM certificates
* Please be informed that this build will overwrite existing DNS records
    * `<yourdomain.tld>`
    * `www.<yourdmain.tld>`
    * `dev.<yourdomain.tld>`
    * `www.dev.<yourdomain.tld>`

## Build Configuration ##

Before running your first build, please make sure that you have your AWS Account properly set up.

As a next step, you have to create the Terrform variables file `terraform.tfvars` with the following content:

    aws_account_id  = "<AWS Account ID>"
    aws_region      = "<AWS Region>"
    aws_profile     = "<AWS Credentials Profile for Terraform>"
    project         = "<The Project Name>"
    component       = "<The Project Component Name>"
    environment     = "<The Project Environment Name>"
    website_domain  = "<The Project Website Domain>"
    credential_file = "<Absolute path to AWS CLI Credentials file>"
    aws_dev_profile = "<AWS Credentials Profile for Development>"
    backend_bucket  = "<AWS S3 bucket for persisting Terraform state file>"

## Initializing the build environment ##

Please make sure to run `make init` before any build attempts to see if your build environemnt and backend configuration is working properly.

## Running the initial build ##

You are now ready to run `make all` in the project top directory

## After running the initial build ##

Please see https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-ssh-unixes.html

You can omit the steps to generate your SSH key from the documentation as the Terraform build does that for you and saves the credentials to the SSM Parameter Store.

* Go to the SSM Parameter Store
* Retrieve the SSH Private Key and ID
* Retrieve the AWS API Access Credentials
* Configure the AWS Credentials Profile for Development withthe AWS API Access Credentials
* Configure your SSH Client to use the SSH Private Key to access Git
* Configure your SSH Client to use the SSH Key ID as user name to access Git

## Version Control for your Terraform Project ##

The initial build creates a CodeCommit Repository for your own copy of this Project.

You can just add it as an additional remote to your Git configuration. If you have successfully finished all prior steps, you should be able to use that origin without any further configuration.

## Before you can start to manage content ##

We are using CodeBuild to compile your website using Hugo. As a prerequisite, we need to create a Docker Image that contains all the necessary tools.

To simply this task, the initial Terraform buld creates a Makefile tha takes care of all the required steps for you.

* Go to the `docker` directory and run `make all`

Once this has been completed successfully, you can start managing content.

## Getting started with Content Management ##

The initial build creates a CodeCommit Repository for your Website content.

You can just add it as a remote to your existing Git configuration. If you have successfully finished all prior steps, you should be able to use that origin without any further configuration.

Please make sure to use the following directory structure and that `Makefile` and `buildspec.yaml` are present. See the next sections for the content that needs to go into these two files.

The usual data for your Hugo project goes to the `src` sub directory.


    /
    | - Makefile
    | - buildspec.yaml
    | - src
        |
        | - config.toml
        | - content
        | - data
        | - layosuts
        | - resources
        | - static
        | - themes
        | - ...

As soon as you commit to the development branch and push to CodeCommit, development build and deployment will trigger

As soon as you commit to the master branch and push to CodeCommit, the production build and deployment will trigger.

Both build processes will also create an invalidation on CloudFront to make sure that changes are quickly propagated.

If you want to test your Website Project locally, you need Hugo installed. Running a local Hugo server is as simple as typing `make run` and hitting return. Stop it using `<CTRL-C>`

### File content: buildspec.yaml ###

    version: 0.2

    phases:
    install:
        commands:
        - echo "Nothing TODO in install"
    pre_build:
        commands:
        - echo "Nothing TODO in pre_build"
    build:
        commands:
        - make all
    post_build:
        commands:
        - echo "Nothing TODO in post_build"


### File content: Makefile ###

    SRCDIR := `pwd`/src
    DSTDIR := `pwd`/build

    all: render upload clean invalidate
    local: render run

    render:
            mkdir -p "${DSTDIR}"
            hugo -v -b "${WEBSITE_URL}" -D -E -F --cleanDestinationDir -s "${SRCDIR}" -d "${DSTDIR}"

    upload:
            aws s3 --delete sync "${DSTDIR}" s3://${WEB_BUCKET_NAME}/

    invalidate:
            aws cloudfront create-invalidation --distribution-id "${CLOUDFRONT_DISTRIBUTION}" --paths '/*'

    clean:
            rm -rf "${DSTDIR}"

    run:
            hugo server -D - -E -Fw -v --enableGitInfo --gc --noHTTPCache --disableFastRender -s "${SRCDIR}" --bind 127.0.0.1 -p 8080 -b http://127.0.0.1/
