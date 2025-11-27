IMG_TAG ?= latest

.PHONY: docker-image
docker-image:
	docker buildx build -f Dockerfile -t ghcr.io/vshn/spks-migration-tool:$(IMG_TAG) --platform linux/amd64 .

.PHONY: push
push: docker-image
	docker push ghcr.io/vshn/spks-migration-tool:$(IMG_TAG)
