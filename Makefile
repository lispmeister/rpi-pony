DOCKER_IMAGE_VERSION=0.0.2
DOCKER_IMAGE_NAME=lispmeister/rpi-pony
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

default: build

build:
	docker build -t $(DOCKER_IMAGE_TAGNAME) .
	docker tag -f $(DOCKER_IMAGE_TAGNAME) $(DOCKER_IMAGE_NAME):latest

push:
	docker push $(DOCKER_IMAGE_NAME)

test:
	docker run --rm $(DOCKER_IMAGE_TAGNAME) echo 'Success.'

version:
	docker run --rm $(DOCKER_IMAGE_TAGNAME) ponyc --version


clean:
exited := $(shell docker ps -a -q -f status=exited)
untagged := $(shell docker images | grep "^<none>" | awk -F " " '{print $3}')
dangling := $(shell docker images -f "dangling=true" -q)
ifneq ($(strip $(exited)),)
	docker rm -v $()
endif
ifneq ($(strip $(untagged)),)
	docker rmi $(untagged)
endif
ifneq ($(strip $(dangling)),)
	docker rmi $(dangling)
endif

