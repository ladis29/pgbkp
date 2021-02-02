#!/bin/sh

mkdir -p /bkp/postgres

echo "$CRON_MIN $CRON_HOUR $CRON_MONTH_DAY $CRON_MONTH $CRON_WEEK_DAY /bkp/bkp_database.sh >> /var/log/cron.log 2>&1" > /bkp/cronjob
echo "# Extra Line to make it a valid cron" >> /bkp/cronjob

cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime
echo "$TIMEZONE" >  /etc/timezone
apk del tzdata

mv /bkp_database.sh /bkp/bkp_database.sh
chmod +x /bkp/bkp_database.sh
crontab /bkp/cronjob

crond -f -l 0