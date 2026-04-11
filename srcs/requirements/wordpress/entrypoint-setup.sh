#!/usr/bin/env bash

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

init_wordpress() {
	wp core download --allow-root

	wp config create \
		--dbname="${MARIADB_DATABASE}" \
		--dbuser="${MARIADB_USER}" \
		--dbpass="${MARIADB_USER_PASSWORD}" \
		--dbhost="mariadb" \
		--allow-root || exit 1

	wp core install \
		--url="${DOMAIN_NAME}" \
		--title="Inception" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--allow-root

	wp user create \
		"${WP_USER}" \
		"${WP_USER_EMAIL}" \
		--role=author \
		--user_pass="${WP_USER_PASSWORD}" \
		--allow-root
}

if [ ! -f "./wp-config.php" ]; then
	ensure_env_value_exists "DOMAIN_NAME"
	ensure_env_value_exists "MARIADB_DATABASE"
	ensure_env_value_exists "MARIADB_USER"
	ensure_env_value_exists "WP_ADMIN_USER"
	ensure_env_value_exists "WP_ADMIN_EMAIL"
	ensure_env_value_exists "WP_USER"
	ensure_env_value_exists "WP_USER_EMAIL"

	fetch_env_value_in_file "MARIADB_USER_PASSWORD"
	fetch_env_value_in_file "WP_ADMIN_PASSWORD"
	fetch_env_value_in_file "WP_USER_PASSWORD"

	init_wordpress
fi

exec "$@"
