FROM alpine:3.12
LABEL maintainer="Ladislau Felisbino<ladis29@gmail.com>"

RUN apk --update add postgresql-client tzdata && rm -rf /var/cache/apk/*

ENV CREATION_DATE /bin/date +%Y%m%d%H%M
ENV RETENTION 10
ENV BKP1_NAME database1_bkp
ENV BKP2_NAME database2_bkp
ENV PGHOST postgres_host
ENV PGUSER postgres
ENV PGPASSWORD postgres-pass
ENV DATABASE1 database1
ENV DATABASE2 database2
ENV TIMEZONE UTC
ENV CRON_MIN 00
ENV CRON_HOUR 20
ENV CRON_MONTH_DAY *
ENV CRON_MONTH *
ENV CRON_WEEK_DAY *

COPY bkp_database.sh /
ADD start.sh /
RUN chmod +x /start.sh

CMD ["sh","start.sh"]