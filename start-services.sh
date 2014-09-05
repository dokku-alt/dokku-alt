#!/bin/bash

export HOME=/root

echo "Starting services..."
service nginx start
service docker start
service ssh start
service rsyslog start

echo "Configuring dokku..."
sshcommand create dokku /usr/local/bin/dokku
dokku plugins-install
PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)
echo "root:$PASSWORD" | chpasswd

echo "SSH Login:"
echo "  user: root"
echo "  password: $PASSWORD"
echo "  ip: $(hostname -I)"

while true; do sleep 1h; done
