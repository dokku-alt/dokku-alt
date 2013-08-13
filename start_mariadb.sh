#!/bin/bash

if [[ ! -z "$1" ]]; then
    mkdir -p /opt/mysql
    cp -a /var/lib/mysql/* /opt/mysql/
    chown -R mysql:mysql /opt/mysql
    chmod -R 755 /opt/mysql
fi
mysqld_safe & sleep 5

if [[ ! -z "$1" ]]; then
    echo "CREATE DATABASE db;" | mysql -u root --password=a_stronk_password
    echo "UPDATE mysql.user SET Password=PASSWORD('$1') WHERE User='root'; FLUSH PRIVILEGES;" | mysql -u root --password=a_stronk_password mysql
    echo "GRANT ALL ON *.* to root@'%' IDENTIFIED BY '$1'; FLUSH PRIVILEGES;" | mysql -u root --password="$1" mysql
fi
