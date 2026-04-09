#!/usr/bin/env sh

ln -sf /etc/nginx/sites-available/inception /etc/nginx/sites-enabled
rm -f /etc/nginx/sites-enabled/default

exec "$@"
