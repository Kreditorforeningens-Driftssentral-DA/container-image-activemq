export TARGET_BUILD_PREPARE   ?= prepare.docker.UBUNTU_2004
export TARGET_BUILD_PROVISION ?= provision.docker.UBUNTU_PREPARED

# Variables passed to PACKER (PKR_VAR_)
export PKR_VAR_activemq_version      ?= '5.16.1'
export PKR_VAR_java_version          ?= openjdk-11-jre-headless
export PKR_VAR_hawtio_version        ?= '2.13.0'
export PKR_VAR_jdbc_postgres_version ?= '42.2.19'

export PKR_VAR_docker_image_name     ?= local/activemq

prepare:
	@packer build -only=${TARGET_BUILD_PREPARE} .
.PHONY: prepare

provision:
	@packer build -only=${TARGET_BUILD_PROVISION} -except=push .
.PHONY: provision

build: base
	@packer build -only=${TARGET_BUILD_PROVISION} -except=push .
.PHONY: build

push:
	@packer build -only=${TARGET_BUILD_PROVISION} .
.PHONY: push

test:
	@docker run --rm -it -p 8161:8161 --tty --name activemq-test ${PKR_VAR_docker_image_name}:development
.PHONY: test

clean:
	@rm -rf ansible/cache/*.tar.gz
	@rm -rf ansible/cache/*.war
	@rm -rf ansible/cache/*.jar
.PHONY: test