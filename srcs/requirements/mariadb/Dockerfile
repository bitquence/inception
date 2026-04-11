FROM debian:bookworm-slim AS mariadb-base

RUN apt update \
	&& apt -y install mariadb-server \
	&& rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/lib/mysql \
	&& mkdir -p /var/lib/mysql /run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /run/mysqld \
	&& chmod 777 /run/mysqld

copy ./entrypoint.sh /entrypoint.sh

STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]

FROM mariadb-base

RUN { \
		echo "[mysqld]"; \
		echo "user = mysql"; \
		echo "port = 3306"; \
		echo "datadir = /var/lib/mysql"; \
		echo "bind-address = 0.0.0.0"; \
	} > /etc/mysql/mariadb.conf.d/inception.cnf
