FROM ubuntu:quantal
MAINTAINER luxifer "luxifer666@gmail.com"

RUN apt-get update
RUN apt-get -y install redis-server

ADD . /usr/bin
RUN chmod +x /usr/bin/start_redis.sh
