FROM debian:bookworm-slim AS mariadb-base

RUN apt update \
	&& apt -y install mariadb-server \
	&& rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/lib/mysql \
	&& mkdir -p /var/lib/mysql /run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /run/mysqld \
	&& chmod 1777 /run/mysqld

copy ./entrypoint.sh /entrypoint.sh

STOPSIGNAL SIGQUIT

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mariadbd"]

FROM mariadb-base

RUN { \
		echo "[mysqld]"; \
		echo "bind-address = 0.0.0.0"; \
		echo "user = mysql"; \
		echo "port = 3306"; \
	} > /etc/mysql/mariadb.conf.d/inception.cnf
