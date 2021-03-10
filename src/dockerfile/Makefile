# Variables passed to PACKER (PKR_VAR_)
export docker_image_name ?= local/activemq
export docker_image_tag  ?= dev
export activemq_version  ?= "5.16.1"

#export PKR_VAR_docker_login_username ?= dist
#export PKR_VAR_docker_login_password ?= kred.container.distrepos.com
#export PKR_VAR_docker_login_server   ?= kred.container.distrepos.com

build:
	@docker build --tag ${docker_image_name}:${docker_image_tag} .
.PHONY: build

test:
	@docker run --rm -it -p 8161:8161 ${docker_image_name}:${docker_image_tag}
.PHONY: test