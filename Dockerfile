# Memcached Dokku plugin
#
# Version 0.1

FROM ubuntu:quantal
MAINTAINER Jannis Leidel "jannis@leidel.info"

RUN apt-get update
RUN apt-get -y install memcached libmemcached-tools

EXPOSE 11211
