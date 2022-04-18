#!/bin/bash
set -e

ls -ld /app/mailman/var
chmod u=rwx,g=rws,o=rx  /app/mailman/var
