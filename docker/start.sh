#!/bin/bash

## copy config files into place inserting secrets as we go
CONFIG_FILE_DIRECTORY=/etc
for CFG_FILE_IN in $(echo etc/*.cfg)
do
    awk '{
           while (match($0,"[$]{[^}]*}")) {
             var = substr($0,RSTART+2,RLENGTH -3)
             gsub("[$]{"var"}",ENVIRON[var])
           }
         }1' < $CFG_FILE_IN  > ${CONFIG_FILE_DIRECTORY}/$(basename $CFG_FILE_IN)
done


## do any housekeeping or clean up here

# Chown the places where mailman wants to write stuff.
chown -R mailman /opt/mailman

## Generate the LMTP files for postfix if needed.
#su-exec mailman mailman aliases

## spin up postfix
#/usr/sbin/postfix start

## launch mailman
#su-exec mailman master --force
