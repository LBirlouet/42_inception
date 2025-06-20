FROM debian:bullseye

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y php php-fpm php-mysql mariadb-client curl wget && \
    curl -sS https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp && \
    mkdir -p /run/php

WORKDIR /var/www/html

RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz

COPY conf/wordpress.conf /usr/local/bin/wp_start.sh
COPY tools/wp_start.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/wp_start.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp_start.sh"]