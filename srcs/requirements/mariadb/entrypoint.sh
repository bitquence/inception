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

	mysqld -umysql --bootstrap --datadir=$DATADIR <<-EOSQL
		FLUSH PRIVILEGES;
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
		CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';

		CREATE DATABASE \`${MARIADB_DATABASE}\`;
		CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_USER_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
		FLUSH PRIVILEGES;
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
