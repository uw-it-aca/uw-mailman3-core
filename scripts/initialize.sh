#!/bin/bash
set -e

echo "Pod Initialization Script"

addgroup -g 1000 -S mailman
adduser -S mailman -G mailman -H -u 1000

mkdir -p /opt/mailman-web-data/fulltext_index
chown mailman /opt/mailman-web-data/fulltext_index
