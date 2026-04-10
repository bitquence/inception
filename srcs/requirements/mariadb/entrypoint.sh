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

	mysqld -u root <<- EOSQL
		CREATE USER 'root'@'${MARIADB_ROOT_HOST}' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}' ;
		GRANT ALL ON *.* TO 'root'@'${MARIADB_ROOT_HOST}' WITH GRANT OPTION ;
		GRANT PROXY ON ''@'%' TO 'root'@'${MARIADB_ROOT_HOST}' WITH GRANT OPTION;
		CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY PASSWORD '${MARIADB_PASSWORD}';
		CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
		GRANT ALL ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
	EOSQL
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
