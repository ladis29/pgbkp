#!/bin/sh

#DELETE OLD BACKUPS FIRST TO PREVENT LACK OF SPACE CAUSED BY THIS TASK
find /bkp/postgres/* -mtime +$RETENTION -exec rm {} \;

#BACKUP 1st DATABASE
pg_dump -h $PGHOST -U $PGUSER -d $DATABASE1 > /bkp/postgres/$BKP1_NAME-$($CREATION_DATE).sql

#BACKUP 2nd WEB DATABASE
pg_dump -h $PGHOST -U $PGUSER -d $DATABASE2 > /bkp/postgres/$BKP2_NAME-$($CREATION_DATE).sql
