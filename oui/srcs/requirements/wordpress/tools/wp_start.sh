#!/bin/bash

# Attendre MariaDB
echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
    sleep 2
done

# Préparer WordPress si ce n'est pas déjà fait
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Preparing WordPress installation..."

    # Télécharger WordPress (dans /var/www/html)
    wp core download --path=/var/www/html --allow-root

    # Créer wp-config
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=$MYSQL_HOST \
        --path=/var/www/html \
        --allow-root

    # Installer WordPress
    wp core install \
        --url=$DOMAIN_NAME \
        --title="My WordPress" \
        --admin_user=$WP_ADMIN \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --path=/var/www/html \
        --allow-root

    # Ajouter un utilisateur
    wp user create $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author \
        --allow-root
fi

# Lancer PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
