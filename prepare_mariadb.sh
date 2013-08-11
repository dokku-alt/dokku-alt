#!/bin/bash

sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
mysqld_safe & sleep 5
echo "CREATE DATABASE db;" | mysql -u root --password=a_stronk_password
if [[ ! -z $2 ]]; then
    echo "$2" | mysql -u root --password=a_stronk_password db
fi
echo "UPDATE mysql.user SET Password=PASSWORD('$1') WHERE User='root'; FLUSH PRIVILEGES;" | mysql -u root --password=a_stronk_password mysql
echo "GRANT ALL ON *.* to root@'%' IDENTIFIED BY '$1'; FLUSH PRIVILEGES;" | mysql -u root --password="$1" mysql
exit 0
