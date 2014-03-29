#!/bin/bash

set -e

if [[ ! -f /opt/postgresql_password ]]; then
	echo "No postgresql password defined"
	exit 1
fi
if [[ ! -f /opt/postgresql/initialized ]]; then
    mkdir -p /opt/postgresql
    cp -a /var/lib/postgresql/* /opt/postgresql/
    chown -R postgres:postgres /opt/postgresql
    DB_PASSWORD="$(cat "/opt/postgresql_password")"
    su postgres -c '/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf' <<EOF
CREATE USER root WITH SUPERUSER PASSWORD '$DB_PASSWORD';
CREATE DATABASE root OWNER root;
EOF
    touch /opt/postgresql/initialized
fi

exec su postgres -c '/usr/lib/postgresql/9.1/bin/postgres -D /var/lib/postgresql/9.1/main -c config_file=/etc/postgresql/9.1/main/postgresql.conf -c "listen_addresses=*"'
