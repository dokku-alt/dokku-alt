#!/bin/bash

source "$(dirname $0)/../dokku_common.sh"

verify_app_name "$APP"

MARIADB_ROOT="$DOKKU_ROOT/.mariadb"
DB_APP_ROOT="$MARIADB_ROOT/$APP"

DB_IMAGE="kloadut/mariadb"
DB_CONTAINER="mariadb_${APP}"
DB_CONTAINER_LINK="mariadb"
DB_ROOT="$DB_APP_ROOT/db"
DB_PASSWORD_FILE="$DB_APP_ROOT/db_password"
DB_CONTAINER_VOLUME="/opt/mysql"
DB_CONTAINER_PASSWORD="/opt/mysql_password"
