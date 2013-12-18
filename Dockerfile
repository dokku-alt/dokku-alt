# Redis Dokku plugin
#
# Version 0.1

FROM ubuntu:quantal
MAINTAINER Jannis Leidel "jannis@leidel.info"

RUN apt-get update
RUN apt-get -y install redis-server
RUN sed -i 's@bind 127.0.0.1@bind 0.0.0.0@' /etc/redis/redis.conf
RUN sed -i 's@data /var/lib/redis@data /opt/redis@' /etc/redis/redis.conf
RUN sed -i 's@daemonize yes@daemonize no@' /etc/redis/redis.conf
RUN sed -i 's@logfile /var/log/redis/redis-server.log@logfile stdout@' /etc/redis/redis.conf

EXPOSE 6379
ENTRYPOINT ['redis-server']
CMD ['/etc/redis/redis.conf']
