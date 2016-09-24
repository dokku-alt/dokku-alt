#!/bin/bash

set -xe

if [ ! -e /usr/lib/apt/methods/https ]; then
	apt-get update
	apt-get install -y apt-transport-https
fi

if [ ! -e /usr/bin/sudo ]; then
  apt-get install sudo
fi

echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
echo deb https://dokku-alt.github.io/dokku-alt / > /etc/apt/sources.list.d/dokku-alt.list

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
apt-key adv --keyserver keys.gnupg.net --recv-keys EAD883AF
apt-get update -y

if [[ -t 0 ]]; then
	apt-get install -y dokku-alt ruby ruby-sinatra
else
	unset UCF_FORCE_CONFFOLD
	export UCF_FORCE_CONFFNEW=YES
	apt-get install -o Dpkg::Options::="--force-confnew" --yes --force-yes dokku-alt ruby ruby-sinatra
fi

set +xe

if [ `lsb_release -sr` != "14.04" ]; then
	echo
	echo "WARNING: dokku-alt works best on Ubuntu 14.04 LTS!"
fi

echo
echo "Almost done!"
echo "Open now web browser pointing to http://$(hostname):2000/ to finish configuartion."
echo "For manual installation instructions press Ctrl-C and visit https://github.com/dokku-alt/dokku-alt."
echo

ruby /usr/local/share/dokku-alt/contrib/dokku-installer.rb
