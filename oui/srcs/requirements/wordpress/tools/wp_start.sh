#!/bin/bash
set -e

echo "Waiting for MariaDB to be ready..."

# On attend que MariaDB réponde au ping avec les bons identifiants root (car wp_user peut ne pas exister au début)
until mysqladmin ping -h"$MYSQL_HOST" -uroot -p"$MYSQL_ROOT_PASSWORD" --silent; do
    echo "MariaDB is unavailable - sleeping"
    sleep 2
done

echo "MariaDB is up - proceeding"

# Si wp_user n'existe pas encore, on le crée avec les droits nécessaires
mysql -h"$MYSQL_HOST" -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%'; FLUSH PRIVILEGES;"

# Préparer WordPress si pas déjà fait
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Preparing WordPress installation..."

    # Télécharger WordPress
    wp core download --path=/var/www/html --allow-root

    # Créer wp-config.php
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$MYSQL_HOST" \
        --path=/var/www/html \
        --allow-root

    # Installer WordPress
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="My WordPress" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path=/var/www/html \
        --skip-email \
        --allow-root

    # Ajouter un utilisateur supplémentaire
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root
else
    echo "WordPress already installed."
fi

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
