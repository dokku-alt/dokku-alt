FROM ubuntu:quantal
MAINTAINER luxifer "luxifer666@gmail.com"

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive \
	apt-get update && \
	apt-get install -y redis-server && \
	sed -i 's@bind 127.0.0.1@bind 0.0.0.0@' /etc/redis/redis.conf && \
	sed -i 's@daemonize yes@daemonize no@' /etc/redis/redis.conf && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get clean && \
	rm /usr/sbin/policy-rc.d

ADD start_redis.sh /usr/bin/start_redis.sh
