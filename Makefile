#BUILD   ?= .docker.ALPINE
name ?= local/activemq
tags ?= ["dev"]

# Variables passed to PACKER (PKR_VAR_)
export PKR_VAR_registry_name           ?= ${name}
export PKR_VAR_registry_tags           ?= ${tags}
export PKR_VAR_activemq_version        ?= '5.16.3'
export PKR_VAR_hawtio_version          ?= '2.14.0'
export PKR_VAR_jdbc_postgres_version   ?= '42.2.24'
export PKR_VAR_java_version            ?= openjdk11-jre-headless
#export PKR_VAR_ansible_playbook_alpine ?= 
.PHONY: validate build push

validate:
	@packer validate ./packer

build: validate
	@packer build --except=push ./packer

push: validate
	@packer build ./packer
