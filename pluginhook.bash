#!/bin/bash

set -eo pipefail

if [[ "$PLUGIN_PATH" == "" ]]; then
	echo "[ERROR] Unable to locate plugins: set \$PLUGIN_PATH" 1>&2
	exit 1
fi

if [[ $# -le 1 ]]; then
	echo "[ERROR] Hook name argument is required" 1>&2
	exit 1
fi

HOOK_NAME="$1"
shift
ARGS="$@"

chainhook() {
	if [[ $# -eq 0 ]]; then
		# sleep 20s
		cat
		sleep 20s
		exit 0
	fi

	HOOK_FILE="$1"
	shift
	"$HOOK_FILE" "$ARGS" | chainhook "$@"
}


if [[ -t 0 ]]; then
	: | chainhook $PLUGIN_PATH/*/$HOOK_NAME
else
	chainhook $PLUGIN_PATH/*/$HOOK_NAME
fi
