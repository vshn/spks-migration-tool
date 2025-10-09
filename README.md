# SPKS migration tool

This tool helps migrating from one instance to another.

Currently supported are Mariadb and Redis.

## Migrate MariaDB

The migration can be triggered via `cf push`.

To migrate create the following migrate.yaml:

```yaml
applications:
  - name: migrate-mariadb
    memory: 64M
    instances: 1
    services:
      - <mariadb-source>
      - <mariadb-destination>
    routes:
      - route: migrate.scapp-corp.swisscom.com
    docker:
      image: ghcr-docker-remote.artifactory.swisscom.com/vshn/spks-migration-tool-mariadb:latest
    command: |
      sleep infinity
    health-check-type: process
    readiness-health-check-type: process
```

Then apply via `cf push -f migrate.yaml`. The application itself doesn't do the migration. For the migration to actually start
a task has to be created:

```bash
cf rt migrate-mariadb --command /mariadb/migrate.sh --name migration
```

Depending on the size of the database it can take a while until the migration is complete.

## Migrate Redis

The Redis migration follows the same pattern as MariaDB. Create a migrate-redis.yaml:

```yaml
applications:
  - name: migrate-redis
    memory: 128M
    instances: 1
    services:
      - <redis-source>
      - <redis-destination>
    docker:
      image: ghcr-docker-remote.artifactory.swisscom.com/vshn/spks-migration-tool-redis:latest
    command: |
      sleep infinity
    health-check-type: process
    readiness-health-check-type: process
```

Then apply via `cf push -f migrate-redis.yaml`. To start the migration, create a task:

```bash
cf rt migrate-redis --command /redis/migrate.sh --name migration
```

The Redis migration uses [redis-shake](https://github.com/tair-opensource/RedisShake/) to replicate all keys from the source to the destination Redis instance.
