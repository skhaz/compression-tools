
.PHONY: build run push

.SILENT:

export DOCKER_BUILDKIT = 0

TAG := skhaz/compression-tools:latest

build:
	docker build -t $(TAG) .

run:
	docker run -it $(TAG)

push:
	docker push $(TAG)