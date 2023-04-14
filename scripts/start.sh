#!/bin/bash
set -e

# set dymically for test/prod
export MAILMAN_HOSTNAME=${MAILMAN_HOSTNAME:-$HOSTNAME}

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
    export DATABASE_URL="url: postgresql://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${DATABASE_HOSTNAME}/${DATABASE_DB_NAME}"
fi

## copy config files into place inserting secrets
CONFIG_FILE_DIRECTORY=/app/mailman/var/etc
CONFIG_TEMPLATE_DIRECTORY=/config
CONFIG_TEMPLATE_EXTENSION=tpl
CONFIG_FILE_EXTENSION=cfg
echo "me: $(whoami)"
echo "ls -ld /app"
ls -ld /app
echo "ls -ld /app/mailman"
ls -ld /app/mailman
echo "ls -ld /app/mailman/var"
ls -ld /app/mailman/var
echo "ls -l /app/mailman/var"
ls -l /app/mailman/var
mkdir -p $CONFIG_FILE_DIRECTORY
for CFG_TEMPLATE_IN in $(echo ${CONFIG_TEMPLATE_DIRECTORY}/*.${CONFIG_TEMPLATE_EXTENSION})
do
    awk '{
           while (match($0,"[$]{[^}]*}")) {
             var = substr($0,RSTART+2,RLENGTH -3)
             gsub("[$]{"var"}",ENVIRON[var])
           }
         }1' < $CFG_TEMPLATE_IN  > ${CONFIG_FILE_DIRECTORY}/$(basename -s .${CONFIG_TEMPLATE_EXTENSION} $CFG_TEMPLATE_IN).${CONFIG_FILE_EXTENSION}
done

crontab /config/core.cron
echo "crontab -l"
crontab -l

souroe "/app/mailman/bin/activate"

# Generate the LMTP files for postfix if needed.
/app/mailman/bin/mailman aliases

## launch mailman
/app/mailman/bin/master --force --verbose
