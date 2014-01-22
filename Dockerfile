FROM ubuntu:quantal
MAINTAINER luxifer "luxifer666@gmail.com"

RUN apt-get update
RUN apt-get -y install redis-server
RUN sed -i 's@bind 127.0.0.1@bind 0.0.0.0@' /etc/redis/redis.conf
RUN sed -i 's@daemonize yes@daemonize no@' /etc/redis/redis.conf

ADD . /bin
RUN chmod +x /bin/start_redis.sh
RUN mkdir -p /var/lib/redis
