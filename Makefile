GROUP=dm0275
IMAGE_NAME=ark-server
# VCS_REF=`git rev-parse --short HEAD`
IMAGE_VERSION=1.0.0
DATE=`date "+%Y.%m.%d"`
QNAME=$(GROUP)/$(IMAGE_NAME)

GIT_TAG=$(QNAME):$(VCS_REF)
LATEST_TAG=$(QNAME):latest
DATE_TAG=$(QNAME):$(DATE)

.PHONY: help
.DEFAULT_GOAL := help


login: ## Login to Docker Registry
	docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_TOKEN}"

build:  ## Build Ark server image
	docker build \
		-t $(DATE_TAG) \
		-t $(LATEST_TAG) .

setup:
	mkdir $(ARK) $(ARK)_mods $(ARK)_conf

push: login
	docker push $(LATEST_TAG)
	docker push $(DATE_TAG)

help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run:
	docker-compose up -d

stop:
	docker-compose down -v