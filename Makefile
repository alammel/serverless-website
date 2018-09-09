TFVARS := terraform.tfvars

all: init validate plan apply
init: backend tfinit

backend:
	bash ./createBackendConfig.sh

tfinit:
	terraform init

validate:
	terraform validate

plan:
	terraform plan -var-file=${TFVARS}

apply:
	terraform apply -auto-approve -var-file=${TFVARS}


