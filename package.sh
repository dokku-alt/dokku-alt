#!/bin/bash
set -e
test -f pluginhook
rm -rf package
mkdir -p package/bin
cp pluginhook package/bin
cd package
fpm -s dir -t deb -n pluginhook -v 0.1 --prefix /usr/local bin
