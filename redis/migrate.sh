#!/bin/bash

set -e -o pipefail

# Parse source and destination from VCAP_SERVICES
source=$(echo $VCAP_SERVICES | jq -r '."redis-k8s"[]')
dest=$(echo $VCAP_SERVICES | jq -r '."redis"[]? // ."redis-premium"[]?')

# Source Redis configuration
SRC_HOST=$(echo $source | jq -r '.credentials.host')
SRC_PORT=$(echo $source | jq -r '.credentials.port // 6379')
SRC_PASSWORD=$(echo $source | jq -r '.credentials.password')

[ -z "$SRC_HOST" ] && echo "ERROR: Missing source host" && exit 1
[ -z "$SRC_PASSWORD" ] && echo "ERROR: Missing source password" && exit 1

# Destination Redis configuration
DST_HOST=$(echo $dest | jq -r '.credentials.host')
DST_PORT=$(echo $dest | jq -r '.credentials.port // 6379')
DST_PASSWORD=$(echo $dest | jq -r '.credentials.password')

[ -z "$DST_HOST" ] && echo "ERROR: Missing destination host" && exit 1
[ -z "$DST_PASSWORD" ] && echo "ERROR: Missing destination password" && exit 1

echo "Migrating from ${SRC_HOST}:${SRC_PORT} to ${DST_HOST}:${DST_PORT}"

# Verify connectivity
redis-cli -h "${SRC_HOST}" -p "${SRC_PORT}" -a "${SRC_PASSWORD}" --no-auth-warning PING > /dev/null || exit 1
redis-cli -h "${DST_HOST}" -p "${DST_PORT}" -a "${DST_PASSWORD}" --no-auth-warning PING > /dev/null || exit 1

# Create redis-shake configuration
cat > /tmp/shake.toml <<EOF
[scan_reader]
address = "${SRC_HOST}:${SRC_PORT}"
password = "${SRC_PASSWORD}"

[redis_writer]
address = "${DST_HOST}:${DST_PORT}"
password = "${DST_PASSWORD}"
off_replace = false

[advanced]
parallel = 4
EOF

redis-shake /tmp/shake.toml

echo "Migration completed successfully"
