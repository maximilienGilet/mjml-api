VERSION ?= $(shell git log --pretty=format:'%h' -n 1)
APP_NAME := mjml-api

default: docker

docker: docker-build docker-push

version:
	@echo -n $(VERSION)

docker-login:
	echo $(DOCKER_PASS) | docker login -u $(DOCKER_USER) --password-stdin

docker-build:
	docker build -t $(DOCKER_USER)/$(APP_NAME):$(VERSION) .

docker-push: docker-login
	docker push $(DOCKER_USER)/$(APP_NAME):$(VERSION)

docker-pull:
	docker pull $(DOCKER_USER)/$(APP_NAME):$(VERSION)

docker-promote: docker-pull
	docker tag $(DOCKER_USER)/$(APP_NAME):$(VERSION) $(DOCKER_USER)/$(APP_NAME):latest

docker-delete:
	curl -X DELETE -u "$(DOCKER_USER):$(DOCKER_CLOUD_TOKEN)" "https://cloud.docker.com/v2/repositories/$(DOCKER_USER)/$(APP_NAME)/tags/$(VERSION)/"

.PHONY: docker version docker-login docker-build docker-push docker-pull docker-promote docker-delete