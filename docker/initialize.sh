#!/bin/bash
set -e

echo "Pod Initialization Script"

addgroup -g 1000 -S mailman
adduser -S mailman -G mailman -H -u 1000

