#!/bin/bash

mysqld
echo "CREATE DATABASE db;" | mysql -u root --password=a_stronk_password
echo "$2" | mysql -u root --password=a_stronk_password db
echo "UPDATE mysql.user SET Password=PASSWORD('$1') WHERE User='root'; FLUSH PRIVILEGES;" | mysql -u root --password=a_stronk_password mysql
echo "GRANT ALL ON *.* to root@'%' IDENTIFIED BY '$1'; FLUSH PRIVILEGES;" | mysql -u root --password="$1" mysql
tailf /var/log/mysql.log
