
.PHONY: build run push

.SILENT:

TAG := skhaz/compression-tools:latest

build:
	docker buildx build --platform linux/amd64 --tag $(TAG) .

run: build
	docker run --interactive --tty $(TAG)

push: build
	docker push $(TAG)