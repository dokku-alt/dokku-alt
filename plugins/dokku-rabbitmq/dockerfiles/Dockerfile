From ubuntu:precise
MAINTAINER jlachowski "jalachowski@gmail.com"

# Make sure that Upstart won't try to start RabbitMQ after apt-get installs it
# https://github.com/dotcloud/docker/issues/446
ADD policy-rc.d /usr/sbin/policy-rc.d
RUN /bin/chmod 755 /usr/sbin/policy-rc.d

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y -qq update > /dev/null
RUN echo "deb http://www.rabbitmq.com/debian/ testing main" >> /etc/apt/sources.list
RUN apt-get install -y -qq wget > /dev/null
RUN wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc -O /tmp/rabbitmq-signing-key-public.asc
RUN apt-key add /tmp/rabbitmq-signing-key-public.asc
RUN apt-get -y -qq update > /dev/null

# Docker work around for upstart: [https://github.com/dotcloud/docker/issues/1024]
# RUN dpkg-divert --local --rename --add /sbin/initctl
# RUN ln -s /bin/true /sbin/initctl

RUN apt-get install -y -qq rabbitmq-server > /dev/null
RUN /usr/sbin/rabbitmq-plugins enable rabbitmq_management

EXPOSE 5672 15672

ADD . /usr/bin
RUN chmod +x /usr/bin/start-rabbitmq.sh
