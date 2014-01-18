#!/bin/bash

if [[ ! -f /opt/rabbitmq/initialized ]]; then
    mkdir -p /opt/rabbitmq
    cp -a /var/lib/rabbitmq/mnesia/* /opt/rabbitmq/
    chown -R rabbitmq:rabbitmq /opt/rabbitmq

    export RABBITMQ_MNESIA_BASE=/opt/rabbitmq
    /usr/sbin/rabbitmq-server &
    # add new user
    rabbitmqctl add_user admin $1
    rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
    rabbitmqctl set_user_tags admin administrator
    # remove default user
    rabbitmqctl delete_user guest
    rabbitmqctl stop
    touch /opt/rabbitmq/initialized
    /usr/sbin/rabbitmq-server
else
    export RABBITMQ_MNESIA_BASE=/opt/rabbitmq
    /usr/sbin/rabbitmq-server
fi
