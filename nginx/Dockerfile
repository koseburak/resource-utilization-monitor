FROM nginx

ARG NGINX_CONF="docker"
COPY ./$NGINX_CONF.conf /etc/nginx/conf.d/default.conf

RUN cat /etc/nginx/conf.d/default.conf