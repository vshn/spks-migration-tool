IMG_TAG ?= latest

.PHONY: docker
docker:
	docker build -t ghcr.io/vshn/spks-migration-tool:$(IMG_TAG) . --platform linux/amd64

.PHONY: push
push: docker
	docker push ghcr.io/vshn/spks-migration-tool:$(IMG_TAG)
