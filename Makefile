# This file was auto-generated, do not edit it directly.
# Instead run bin/update_build_scripts from
# https://github.com/das7pad/sharelatex-dev-env

export BRANCH_NAME ?= $(shell git rev-parse --abbrev-ref HEAD)
export BUILD_NUMBER ?= local
export COMMIT ?= $(shell git rev-parse HEAD)
export RELEASE ?= $(shell git describe --tags --always | sed 's/-g/-/;s/^v//')

# DOCKER_REGISTRY=other make ...
DOCKER_REGISTRY ?= local

# SHARELATEX_DOCKER_REPOS=foo/bar make ...
SHARELATEX_DOCKER_REPOS ?= $(DOCKER_REGISTRY)/sharelatex

# IMAGE_BARE=foo/bar/runner make ...
IMAGE_BARE ?= $(SHARELATEX_DOCKER_REPOS)/lint-runner

IMAGE_BRANCH_DEV = $(IMAGE_BARE):dev
IMAGE_BRANCH = $(IMAGE_BARE):$(BRANCH_NAME)
IMAGE = $(IMAGE_BRANCH)-$(BUILD_NUMBER)
IMAGE_FINAL = $(IMAGE_BARE):$(RELEASE)

NODE_VERSION ?= 12.16.2
IMAGE_NODE ?= $(DOCKER_REGISTRY)/node:$(NODE_VERSION)

pull_node:
	docker pull $(IMAGE_NODE)
	docker tag $(IMAGE_NODE) node:$(NODE_VERSION)

pull_cache_branch_current:
	docker pull $(IMAGE_BRANCH)
	docker tag $(IMAGE_BRANCH) $(IMAGE)-cache

pull_cache_branch_dev:
	docker pull $(IMAGE_BRANCH_DEV)
	docker tag $(IMAGE_BRANCH_DEV) $(IMAGE)-cache

pull_cache:
	$(MAKE) pull_cache_branch_current \
	|| $(MAKE) pull_cache_branch_dev \
	|| echo 'Nothing cached yet!'

clean_pull_cache:
	docker rmi --force \
		$(IMAGE_BRANCH) \
		$(IMAGE_BRANCH_DEV) \

build:
	docker build \
		--tag $(IMAGE) \
		--cache-from $(IMAGE)-cache \
		--build-arg NODE_VERSION \
		--build-arg COMMIT \
		--build-arg DATE=$(shell date --rfc-3339=s | sed 's/ /T/') \
		--build-arg RELEASE \
		.

test:
	docker run --rm $(IMAGE) eslint --version
	docker run --rm $(IMAGE) prettier-eslint --version

push:
	docker push $(IMAGE)
	docker tag $(IMAGE) $(IMAGE_BRANCH)
	docker push $(IMAGE_BRANCH)
	docker tag $(IMAGE) $(IMAGE_FINAL)
	docker push $(IMAGE_FINAL)

clean_push:
	docker rmi --force \
		$(IMAGE_BRANCH) \
		$(IMAGE_FINAL) \

clean:
	docker rmi --force \
		$(IMAGE) \
		$(IMAGE)-cache \
