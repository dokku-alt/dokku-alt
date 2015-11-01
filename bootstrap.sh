#!/bin/bash

set -xe

DEBIAN_CODE_NAME=$(lsb_release -sc)
DEBIAN=${DEBIAN:-$([[ `lsb_release -is` == "Debian"   ]] && echo -n debian || echo -n ubuntu  )}

if [ ! -e /usr/lib/apt/methods/https ]; then
	apt-get update
	apt-get install -y apt-transport-https
fi

case $DEBIAN_CODE_NAME in
    wheezy|jessie)
        echo "deb http://http.debian.net/debian ${DEBIAN_CODE_NAME}-backports main" > /etc/apt/sources.list.d/${DEBIAN_CODE_NAME}-backports.list
        ;;
        *)
        ;;
esac

wget -qO- https://get.docker.com/gpg | sudo apt-key add -
wget -qO- https://get.docker.com/ | sh

echo deb https://dokku-alt.github.io/dokku-alt / > /etc/apt/sources.list.d/dokku-alt.list


if [[ -t 0 ]]; then
	apt-get install -y dokku-alt ruby ruby-sinatra
else
	unset UCF_FORCE_CONFFOLD
	export UCF_FORCE_CONFFNEW=YES
	apt-get install -o Dpkg::Options::="--force-confnew" --yes --force-yes dokku-alt ruby ruby-sinatra
fi

set +xe

if [ $(lsb_release -sr) != "14.04" ] || [ ${DEBIAN} = "debian "]; then
	echo
	echo "WARNING: dokku-alt works best on Ubuntu 14.04 LTS! or Debian"
fi

echo
echo "Almost done!"
echo "Open now web browser pointing to http://$(hostname):2000/ to finish configuartion."
echo "For manual installation instructions press Ctrl-C and visit https://github.com/dokku-alt/dokku-alt."
echo

ruby /usr/local/share/dokku-alt/contrib/dokku-installer.rb
