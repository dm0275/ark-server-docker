GROUP=dm0275
IMAGE_NAME=ark-server
# VCS_REF=`git rev-parse --short HEAD`
IMAGE_VERSION=1.0.0
QNAME=$(GROUP)/$(IMAGE_NAME)

GIT_TAG=$(QNAME):$(VCS_REF)
LATEST_TAG=$(QNAME):latest

.PHONY: help
.DEFAULT_GOAL := help


login: ## Login to Docker Registry
	docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_TOKEN}"

build:  ## Build Ark server image
	docker build \
		-t $(LATEST_TAG) .

push: login
	docker push $(LATEST_TAG)

help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run:
	docker-compose up -d