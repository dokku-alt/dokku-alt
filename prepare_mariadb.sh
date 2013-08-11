#!/bin/bash

mysqld_safe & sleep 5
echo "CREATE DATABASE db;" | mysql -u root --password=a_stronk_password
echo "UPDATE user set host=’%’ where user=’root’;" | mysql -u root --password=a_stronk_password
if [[ ! -z $2 ]]; then
    echo "$2" | mysql -u root --password=a_stronk_password -p 'db'
fi
echo "UPDATE mysql.user SET Password=PASSWORD('$1') WHERE User='root'; FLUSH PRIVILEGES;" | mysql -u root --password=a_stronk_password
exit 0
