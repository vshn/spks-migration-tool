IMG_TAG ?= latest

.PHONY: docker-mariadb
docker-mariadb:
	docker buildx build -f mariadb/Dockerfile -t ghcr.io/vshn/spks-migration-tool-mariadb:$(IMG_TAG) --platform linux/amd64 .

.PHONY: push-mariadb
push-mariadb: docker-mariadb
	docker push ghcr.io/vshn/spks-migration-tool-mariadb:$(IMG_TAG)

.PHONY: docker-redis
docker-redis:
	docker buildx build -f redis/Dockerfile -t ghcr.io/vshn/spks-migration-tool-redis:$(IMG_TAG) --platform linux/amd64 .

.PHONY: push-redis
push-redis: docker-redis
	docker push ghcr.io/vshn/spks-migration-tool-redis:$(IMG_TAG)
