
.PHONY: build run push

.SILENT:

export DOCKER_BUILDKIT = 0

TAG := skhaz/compression-tools:latest

build:
	docker build -t $(TAG) .

run: build
	docker run -it $(TAG)

push: build
	docker push $(TAG)