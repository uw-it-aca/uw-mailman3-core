#!/bin/bash
set -e

# make sure pvc is mounted
stat /app/mailman/var &> /dev/null
