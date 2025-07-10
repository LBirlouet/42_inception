FROM debian:bullseye

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y php php-fpm php-mysql mariadb-client curl wget && \
    curl -sS https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp && \
    mkdir -p /run/php

# Supprimer le pool par défaut pour éviter les conflits
RUN rm -f /etc/php/7.4/fpm/pool.d/www.conf

# Copier le pool personnalisé
COPY conf/wordpress.conf /etc/php/7.4/fpm/pool.d/

# Définir le répertoire de travail
WORKDIR /var/www/html

# Télécharger et extraire WordPress
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz

# Copier le script de démarrage
COPY tools/wp_start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp_start.sh

# Exposer le port utilisé par PHP-FPM
EXPOSE 9000

# Lancer le script d'init WordPress
ENTRYPOINT ["/usr/local/bin/wp_start.sh"]
