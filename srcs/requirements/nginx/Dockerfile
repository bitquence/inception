FROM debian:bookworm-slim AS nginx-base

RUN apt update \
	&& apt -y install nginx \
	&& rm -rf /var/lib/apt/lists/*
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]

FROM nginx-base

EXPOSE 443

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
