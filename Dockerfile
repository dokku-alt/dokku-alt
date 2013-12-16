# Memcached Dokku plugin
#
# Version 0.1

FROM ubuntu:quantal
MAINTAINER Jannis Leidel "jannis@leidel.info"

RUN apt-get update
RUN apt-get -y install memcached libmemcached-dev
RUN service memcached stop

EXPOSE 11211

ENTRYPOINT  ["/usr/bin/memcached"]
