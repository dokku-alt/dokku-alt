#!/bin/bash

set -eo pipefail
[[ $DOKKU_TRACE ]] && set -x

function info()
{
	echo "-----> $@"
}

function verbose()
{
	echo "       $@"
}

function fail()
{
	echo "$@" 1>&2
	exit 1
}

function generate_random_password()
{
	< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-16}
}

function verify_app_name()
{
	APP="$1"
	[ "$APP" == "" ] && fail "You must specify an app name"
    NAPP="${APP//[^a-zA-Z0-9_-]//}"
	[ "$APP" != "$NAPP" ] && fail "Invalid app name"
	[ ! -d "$DOKKU_ROOT/$APP" ] && fail "App $APP doesn't exist"
	return 0
}

function require_image()
{
	IMAGES=$(docker images "$1" | wc -l)
	[ $IMAGES -ne 0 ] && return
	fail "$1 image not found... Did you run 'dokku plugins-install' ?"
}

function deploy_app()
{
  APP="$1";

  info "Deploying $APP ..."
  dokku deploy $APP
  info "Deploy complete!"
}

function commit_image()
{
	read ID
	test $(docker wait "$ID") -eq 0
	docker commit "$ID" "$@" > /dev/null
	docker rm -f "$ID"
}

if [ "$DOKKU_ROOT" == "" ]
then
	fail "DOKKU_ROOT not set"
fi

CWD="$(cd "$(dirname "$0")" && pwd)"
