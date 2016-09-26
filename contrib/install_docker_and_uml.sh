#!/bin/bash

set -xe

DEBIAN_CODE_NAME=$(lsb_release -sc)
DEBIAN=${DEBIAN:-$([[ `lsb_release -is` == "Debian"   ]] && echo -n debian || echo -n ubuntu  )}

sudo sh -c "wget http://nginx.org/keys/nginx_signing.key -O - | apt-key add -"
sudo sh -c "echo deb http://nginx.org/packages/${DEBIAN}/ ${DEBIAN_CODE_NAME} nginx > /etc/apt/sources.list.d/nginx.list"
sudo sh -c "wget -qO- https://get.docker.com/gpg | sudo apt-key add -"
sudo sh -c "wget -qO- https://get.docker.com/ | sh"
sudo apt-get update
sudo mkdir -p /var/lib/docker
echo exit 101 | sudo tee /usr/sbin/policy-rc.d
sudo chmod +x /usr/sbin/policy-rc.d
sudo apt-get install -y apt-transport-https locales git make \
	curl software-properties-common \
	nginx dnsutils aufs-tools \
	dpkg-dev openssh-server man-db \
	apache2-utils
curl -sLo linux https://github.com/jpetazzo/sekexe/raw/master/uml
chmod +x linux

if mount | grep /dev/shm | grep noexec; then
	sudo mount -o remount,exec /dev/shm
fi
