#!/bin/bash

export DOKKU_ROOT=${DOKKU_ROOT:="/home/dokku"}
export PLUGIN_PATH=${PLUGIN_PATH:="/var/lib/dokku-alt/plugins"}
export DOKKU_NOT_IMPLEMENTED_EXIT=10
export DOKKU_VALID_EXIT=0

# locale
export LANGUAGE=${LANGUAGE:-en_US.UTF-8}
export LANG=${LANG:-en_US.UTF-8}
export LC_ALL=${LC_ALL:-en_US.UTF-8}

# it fixes some not nice docker errors
cd $DOKKU_ROOT

source "$PLUGIN_PATH/dokku_common"

[[ -f $DOKKU_ROOT/dokkurc ]] && source $DOKKU_ROOT/dokkurc

echo "Starting dokku daemon..."

# hook to some signals
terminate() {
	exit 1
}

cleanup() {
	echo "Dokku daemon cleaned up!"
}

trap terminate TERM INT
trap cleanup EXIT

# run daemon-tick: in the future there maybe even more
while true
do
	: | pluginhook daemon-tick
	sleep 5s
done
