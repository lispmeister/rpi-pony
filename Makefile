DOCKER_IMAGE_VERSION=0.0.3
DOCKER_IMAGE_NAME=lispmeister/rpi-pony
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

default: help

print-%  : ; @echo $* = $($*)

build: ## Build the Docker image
	docker build -t $(DOCKER_IMAGE_TAGNAME) .
	docker tag -f $(DOCKER_IMAGE_TAGNAME) $(DOCKER_IMAGE_NAME):latest

push:  ## Push Docker image to Docker Hub
	docker push $(DOCKER_IMAGE_NAME)

test:  ## Test execution of container
	docker run --rm $(DOCKER_IMAGE_TAGNAME) echo 'Success.'

version: ## Print version installed
	docker run --rm $(DOCKER_IMAGE_TAGNAME) ponyc --version

exited := $(shell docker ps -a -q -f status=exited)
untagged := $(shell (docker images | grep "^<none>" | awk -F " " '{print $$3}'))
dangling := $(shell docker images -f "dangling=true" -q)
tag := $(shell docker images | grep "$(DOCKER_IMAGE_NAME)" | grep "$(DOCKER_IMAGE_VERSION)" |awk -F " " '{print $$3}')
latest := $(shell docker images | grep "$(DOCKER_IMAGE_NAME)" | grep "latest" | awk -F " " '{print $$3}')

clean:  ## Clean old Docker images
ifneq ($(strip $(latest)),)
	@echo "Removing latest $(latest) image"
	docker rmi "$(DOCKER_IMAGE_NAME):latest"
endif
ifneq ($(strip $(tag)),)
	@echo "Removing tag $(tag) image"
	docker rmi "$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)"
endif
ifneq ($(strip $(exited)),)
	@echo "Cleaning exited containers: $(exited)"
	docker rm -v $(exited)
endif
ifneq ($(strip $(dangling)),)
	@echo "Cleaning dangling images: $(dangling)"
	docker rmi $(dangling)
endif
	@echo 'Done cleaning.'

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
