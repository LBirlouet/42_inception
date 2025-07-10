FROM debian:bullseye

# Installer PHP, extensions, client MariaDB et outils utiles
RUN apt-get update && \
    apt-get install -y \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    mariadb-client \
    curl \
    wget \
    unzip && \
    mkdir -p /run/php

# Installer WP-CLI
RUN curl -sS https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

# Créer le dossier de travail
WORKDIR /var/www/html

# Télécharger WordPress (à runtime on le re-télécharge mais c’est bien pour build-time aussi)
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz

# Copier la configuration PHP-FPM (www.conf corrigé)
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Copier le script de démarrage
COPY tools/wp_start.sh /usr/local/bin/wp_start.sh
RUN chmod +x /usr/local/bin/wp_start.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp_start.sh"]
