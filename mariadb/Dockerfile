FROM alpine:3.22

RUN apk --update add mariadb-client bash jq

ADD mariadb/migrate.sh /mariadb/migrate.sh

ENTRYPOINT [ "/mariadb/migrate.sh" ]
