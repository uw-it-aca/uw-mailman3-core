#!/bin/bash
set -e

# make sure pvc is mounted
stat /opt/mailman &> /dev/null
