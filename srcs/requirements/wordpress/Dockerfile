FROM debian:bookworm-slim AS wordpress-base

RUN apt update \
	&& apt -y install \
		php8.2-mysql \
		php8.2-curl \
		php8.2-dom \
		php8.2-imagick \
		php8.2-mbstring \
		php8.2-zip \
		php8.2-gd \
		php8.2-intl \
		php8.2-fpm \
		curl \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -o /usr/local/bin/wp -f https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x /usr/local/bin/wp

CMD ["php-fpm8.2", "-F"]

FROM wordpress-base

RUN sed -i 's/^listen = .*$/listen = 9000/' /etc/php/8.2/fpm/pool.d/www.conf \
	&& echo '\n[global]\nprocess_control_timeout = 1s' >> /etc/php/8.2/fpm/php-fpm.conf

WORKDIR /var/www/html

COPY ./entrypoint-setup.sh /entrypoint.sh

CMD ["php-fpm8.2", "-F"]
ENTRYPOINT ["/entrypoint.sh"]
