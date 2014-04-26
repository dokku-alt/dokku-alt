#!/usr/bin/env bash
set -eo pipefail
export DEBIAN_FRONTEND=noninteractive
export DOKKU_REPO=${DOKKU_REPO:-"https://github.com/dokku-alt/dokku-alt.git"}
export DOKKU_TAG=${DOKKU_TAG:-origin/master}

if ! which apt-get &>/dev/null
then
  echo "This installation script requires apt-get. For manual installation instructions, consult https://github.com/dokku-alt/dokku-alt ."
  exit 1
fi

if [[ `lsb_release -sr` != "14.04" ]]; then
	echo "dokku-alt requires Ubuntu 14.04 LTS!"
	exit 1
fi

apt-get update
apt-get install -y git make curl software-properties-common ruby

cd ~ && test -d dokku-alt || git clone $DOKKU_REPO
cd dokku-alt
git fetch origin
git checkout $DOKKU_TAG

make install

echo
echo "Almost done!"
echo "Open now web browser pointing to http://$(hostname):8080/ to finish configuartion."
echo "For manual installation instructions press Ctrl-C and visit https://github.com/dokku-alt/dokku-alt."
ruby contrib/dokku-installer.rb
