# Redis Dokku plugin
#
# Version 0.1

FROM ubuntu:quantal
MAINTAINER Jannis Leidel "jannis@leidel.info"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y install software-properties-common && \
    add-apt-repository ppa:chris-lea/redis-server && \
    apt-get update && \
    apt-get -y install redis-server

RUN sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf && \
    sed -i 's/data \/var\/lib\/redis/data \/opt\/redis/' /etc/redis/redis.conf && \
    sed -i 's/daemonize yes/daemonize no/' /etc/redis/redis.conf && \
    sed -i 's/logfile \/var\/log\/redis\/redis-server\.log/logfile \/opt\/redis\/redis-server\.log/' /etc/redis/redis.conf && \
    cat /etc/redis/redis.conf

EXPOSE 6379
