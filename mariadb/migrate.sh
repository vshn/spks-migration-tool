#!/bin/bash

set -e -o pipefail

# Needs to be verified that the ranges are correct...
source=$(echo $VCAP_SERVICES | jq -r '."mariadb-k8s-database"[] | select(.credentials.host | (contains("10.250") or contains("10.144") ))')
dest=$(echo $VCAP_SERVICES | jq -r '."mariadb-k8s-database"[] | select(.credentials.host | contains("10.197"))')

# Source
SRC_HOST=$(echo $source | jq -r '.credentials.host')
[ -z "$SRC_HOST" ] && echo "Missing source host in env var" && exit 1

SRC_DATABASE=$(echo $source | jq -r '.credentials.database')
[ -z "$SRC_HOST" ] && echo "Missing source database in env var" && exit 1

SRC_USER=$(echo $source | jq -r '.credentials.username')
[ -z "$SRC_HOST" ] && echo "Missing source user in env var" && exit 1

SRC_PASSWORD=$(echo $source | jq -r '.credentials.password')
[ -z "$SRC_HOST" ] && echo "Missing source password in env var" && exit 1

# Destination
DST_HOST=$(echo $dest | jq -r '.credentials.host')
[ -z "$SRC_HOST" ] && echo "Missing destination host in env var" && exit 1

DST_DATABASE=$(echo $dest | jq -r '.credentials.database')
[ -z "$SRC_HOST" ] && echo "Missing destination database in env var" && exit 1

DST_USER=$(echo $dest | jq -r '.credentials.username')
[ -z "$SRC_HOST" ] && echo "Missing destination user in env var" && exit 1

DST_PASSWORD=$(echo $dest | jq -r '.credentials.password')
[ -z "$SRC_HOST" ] && echo "Missing destination password in env var" && exit 1

mariadb-dump --skip-ssl --user=$SRC_USER -p$SRC_PASSWORD -h $SRC_HOST $SRC_DATABASE | mariadb --user=$DST_USER -p$DST_PASSWORD -h $DST_HOST $DST_DATABASE
