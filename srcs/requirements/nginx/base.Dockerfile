FROM debian:bookworm-slim

RUN apt update \
	&& apt -y install nginx \
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
