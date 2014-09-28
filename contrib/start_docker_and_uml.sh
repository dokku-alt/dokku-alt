#!/bin/bash

sudo ./linux quiet mem=2500M \
	rootfstype=hostfs rw \
	eth0=slirp,,/usr/bin/slirp-fullbolt \
	init=$(pwd)/contrib/uml_init.sh \
	WORKDIR=$(pwd) \
	HOME=/root \
	"$@"

if [[ -f /uml_exit_code ]]; then
	exit $(cat /uml_exit_code)
fi
