#!/usr/bin/env bash

DATADIR=/var/lib/mysql

set -e

ensure_env_value_exists() {
	local var="$1"
	if [ -z "${var}" ]; then
		echo "environment variable ${var} was not set"
		exit 1
	fi
}

fetch_env_value_in_file() {
	local var_name="$1"
	local file_var_name="${var_name}_FILE"
	local file_path="${!file_var_name}"

	if [ -f "$file_path" ]; then
		printf -v "$var_name" "%s" "$(cat "$file_path")"
	else
		echo "Error: File path in $file_var_name ($file_path) not found." >&2
		exit 1
	fi
}

init_db() {
	mkdir -p "$DATADIR/"

	mysql_install_db --basedir=/usr --datadir=$DATADIR --user=mysql > /dev/null

	service mariadb start

	mysql -e "CREATE DATABASE \`${MARIADB_DATABASE}\`;"
	mysql -e "CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_USER_PASSWORD}';"
	mysql -e "GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';"
	mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';"
	mysql -e "FLUSH PRIVILEGES;"
	mysql -u root --skip-password -e "ALTER USER 'root'@'${MARIADB_ROOT_HOST}' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';"

	service mariadb stop
}

if [ ! -d "$DATADIR/mysql" ]; then
	ensure_env_value_exists "MARIADB_ROOT_HOST"
	ensure_env_value_exists "MARIADB_DATABASE"
	ensure_env_value_exists "MARIADB_USER"
	fetch_env_value_in_file "MARIADB_USER_PASSWORD"
	fetch_env_value_in_file "MARIADB_ROOT_PASSWORD"

	init_db
fi

exec "$@"
