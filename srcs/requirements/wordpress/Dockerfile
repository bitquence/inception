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

RUN curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-latest.tar.gz" \
	&& tar -xzf wordpress.tar.gz -C /usr/src/ \
	&& rm wordpress.tar.gz \
	&& chown -R www-data:www-data /usr/src/wordpress

CMD ["php-fpm8.2", "-F"]

FROM wordpress-base

RUN sed -i 's/^listen = .*$/listen = 9000/' /etc/php/8.2/fpm/pool.d/www.conf \
	&& echo '\n[global]\nprocess_control_timeout = 1s' >> /etc/php/8.2/fpm/php-fpm.conf
