#!/bin/bash
set -e

# setup database for the provided environment
if [ "$ENV" = "localdev" ]
then
    mkdir /app/database
    chown mailman:mailman /app/database
    export DATABASE_CLASS=""
    export DATABASE_URL="url: sqlite:////app/database/sqlite.db"
else
    # url: postgres://mailman:mailmanpass@database/mailman
    export DATABASE_CLASS="class: mailman.database.postgresql.PostgreSQLDatabase"
    export DATABASE_URL="url: postgres://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${DATABASE_HOSTNAME}/${DATABASE_DB_NAME}"
fi

## copy config files into place inserting secrets
CONFIG_FILE_DIRECTORY=/app/mailman/var/etc
mkdir -p $CONFIG_FILE_DIRECTORY
for CFG_FILE_IN in $(echo /app/conf/*.cfg)
do
    awk '{
           while (match($0,"[$]{[^}]*}")) {
             var = substr($0,RSTART+2,RLENGTH -3)
             gsub("[$]{"var"}",ENVIRON[var])
           }
         }1' < $CFG_FILE_IN  > ${CONFIG_FILE_DIRECTORY}/$(basename $CFG_FILE_IN)
done

## do any housekeeping or clean up


# Chown the places where mailman wants to write stuff.
#chown -R mailman:mailman /app/mailman

source "/app/mailman/bin/activate"

# set dymically for test/prod
export MAILMAN_HOSTNAME=${MAILMAN_HOSTNAME:-$HOSTNAME}

# Generate the LMTP files for postfix if needed.
# /app/mailman/bin/mailman aliases

## spin up postfix
# su-exec root /usr/sbin/postfix start

## launch mailman
/app/mailman/bin/master --force --verbose
