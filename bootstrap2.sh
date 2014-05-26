#!/bin/bash

set -xe

if [ ! -e /usr/lib/apt/methods/https ]; then
	apt-get update
	apt-get install -y apt-transport-https
fi

echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
echo deb http://dokku-alt.github.io/dokku-alt dokku-alt main > /etc/apt/sources.list.d/docker.list

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
wget -O - http://dokku-alt.github.io/dokku-alt/dokku-alt.gpg.key | sudo apt-key add -
apt-get update
apt-get install dokku-alt
