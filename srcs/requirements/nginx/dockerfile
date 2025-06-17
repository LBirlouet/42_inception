FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    && apt-get install -y nginx openssl \
    && mkdir -p /etc/nginx/ssl \
    # && openssl req -x509 -nodes -days 365 -newkey rsa:
    # pas sur a verif
    && rm -rf /var/lib/apt/lists/*
    # pareil

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod 777 /var/www/html \
    && chown -R www-data:www-data /var/www/html \

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]