#!/bin/bash
# forked from https://gist.github.com/jpetazzo/5494158

echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/9.1/main/pg_hba.conf
su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "CREATE USER root WITH SUPERUSER PASSWORD '$1';"
su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres           -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf  -c listen_addresses=*" 
