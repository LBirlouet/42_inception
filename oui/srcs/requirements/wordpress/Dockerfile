FROM debian:bullseye

# Installation PHP, PHP-FPM, MariaDB client, curl, wget
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y php php-fpm php-mysql mariadb-client curl wget && \
    curl -sS https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp && \
    mkdir -p /run/php

WORKDIR /var/www/html

# Téléchargement WordPress
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz

# 👇 Copie du bon fichier www.conf
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# (optionnel) Ajout d’un sed en backup pour écraser l’éventuel fichier du cache Docker
RUN sed -i "s|^listen = .*|listen = 0.0.0.0:9000|" /etc/php/7.4/fpm/pool.d/www.conf

# Script de démarrage
COPY tools/wp_start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp_start.sh

EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/wp_start.sh"]
