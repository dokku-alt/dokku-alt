#!/bin/bash

export HOME=/root

for i in $(seq 1 1000)
do
	if docker ps 1>/dev/null 2>/dev/null; then
		break
	fi

	echo "Waiting for docker ($i)..."
	sleep 3s
done

echo "Configuring dokku..."
sshcommand create dokku /usr/local/bin/dokku
dokku plugins-install
PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)

echo "root:$PASSWORD" | chpasswd

echo "SSH Login:"
echo "  user: root"
echo "  password: $PASSWORD"
echo "  ip: $(hostname -I)"

[[ "$1" == "exit" ]] && exit

exec dokku-daemon
