DOCKER_IMAGE_VERSION=0.0.1
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