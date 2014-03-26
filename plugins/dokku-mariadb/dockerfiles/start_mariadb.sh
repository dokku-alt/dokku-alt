#!/bin/bash

if [[ ! -f /opt/mysql/initialized ]]; then
    mkdir -p /opt/mysql
    cp -a /var/lib/mysql/* /opt/mysql/
    chown -R mysql:mysql /opt/mysql
    chmod -R 755 /opt/mysql
fi
if [[ ! -f /opt/mysql_password ]]; then
	echo "No mysql password defined"
	exit 1
fi
sleep 2
mysqld_safe &
sleep 8
if [[ ! -f /opt/mysql/initialized ]]; then
	DB_PASSWORD="$(cat "/opt/mysql_password")"
	mysql -u root --password=a_stronk_password <<EOF
CREATE DATABASE db;
UPDATE mysql.user SET Password=PASSWORD('$DB_PASSWORD') WHERE User='root';
FLUSH PRIVILEGES;
GRANT ALL ON *.* to root@'%' IDENTIFIED BY '$DB_PASSWORD';
FLUSH PRIVILEGES;
EOF
    touch /opt/mysql/initialized
fi
tailf /var/log/mysql.log
