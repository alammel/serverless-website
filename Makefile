TFVARS := terraform.tfvars

all: validate plan apply
all-init: init all

init:
	terraform init

validate:
	terraform validate

plan:
	terraform plan -var-file=${TFVARS}

apply:
	terraform apply -auto-approve -var-file=${TFVARS}


