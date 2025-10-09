FROM alpine:3.22

RUN apk --update add bash jq curl redis

# Install redis-shake
ARG REDIS_SHAKE_VERSION=4.2.2
RUN curl -fsSL https://github.com/tair-opensource/RedisShake/releases/download/v${REDIS_SHAKE_VERSION}/redis-shake-linux-amd64.tar.gz -o /tmp/redis-shake.tar.gz && \
    tar -xzf /tmp/redis-shake.tar.gz -C /usr/local/bin && \
    rm /tmp/redis-shake.tar.gz && \
    chmod +x /usr/local/bin/redis-shake

ADD redis/migrate.sh /redis/migrate.sh
RUN chmod +x /redis/migrate.sh

ENTRYPOINT [ "/redis/migrate.sh" ]
