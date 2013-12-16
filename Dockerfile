# Memcached Dokku plugin
#
# Version 0.1

FROM ubuntu:quantal
MAINTAINER Jannis Leidel "jannis@leidel.info"

RUN apt-get update
RUN apt-get -y install memcached libmemcached-dev libmemcached-tools

EXPOSE 11211

CMD service memcached start && tail -F /var/log/memcached.log
