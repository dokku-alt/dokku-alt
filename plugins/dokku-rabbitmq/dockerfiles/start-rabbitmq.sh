#!/bin/bash

export RABBITMQ_MNESIA_BASE=/opt/rabbitmq

if [[ ! -f /opt/rabbitmq/initialized ]]; then
    mkdir -p /opt/rabbitmq
    cp -a /var/lib/rabbitmq/mnesia/* /opt/rabbitmq/
    chown -R rabbitmq:rabbitmq /opt/rabbitmq
    touch /opt/rabbitmq/initialized
fi
if [[ ! -z "$1" ]]; then
    /usr/sbin/rabbitmq-server -detached
    sleep 6
    # add new user
    rabbitmqctl add_user admin $1
    rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
    rabbitmqctl set_user_tags admin administrator
    # remove default user
    rabbitmqctl delete_user guest
    rabbitmqctl stop
    sleep 4
fi

/usr/sbin/rabbitmq-server
