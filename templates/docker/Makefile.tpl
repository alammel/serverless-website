NAME := ${image_name}
RTAG := ${image_tag}
REGN := ${aws_region}
PFLE := ${aws_profile}

all: login build push

build:
	docker build -t $${NAME} .
	docker tag      $${NAME} $${RTAG}
 
push:
	docker push $${RTAG}
 
login:
	`aws --profile $${PFLE} --region $${REGN} ecr get-login --no-include-email`
