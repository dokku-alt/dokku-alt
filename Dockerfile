# Memcached Dokku plugin
#
# Version 0.1

FROM ubuntu:quantal
MAINTAINER Jannis Leidel "jannis@leidel.info"

RUN apt-get update
RUN apt-get -y install memcached libmemcached-dev
RUN service memcached stop

CMD memcached -u memcache -v -p 11211 -m 64 -l 0.0.0.0
