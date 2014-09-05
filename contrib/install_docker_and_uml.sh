#!/bin/bash

set -xe

sudo add-apt-repository ppa:nginx/stable -y
sudo sh -c "wget -qO- https://get.docker.io/gpg | apt-key add -"
sudo sh -c "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo mkdir -p /var/lib/docker
echo exit 101 | sudo tee /usr/sbin/policy-rc.d
sudo chmod +x /usr/sbin/policy-rc.d
sudo apt-get install -y slirp lxc-docker aufs-tools cgroup-lite \
	apt-transport-https locales git make \
	curl software-properties-common \
	nginx dnsutils aufs-tools \
	dpkg-dev openssh-server man-db \
	apache2-utils
curl -sLo linux https://github.com/jpetazzo/sekexe/raw/master/uml
chmod +x linux

if mount | grep /dev/shm | grep noexec; then
	sudo mount -o remount,exec /dev/shm
fi
