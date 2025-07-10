#!/bin/bash

# test
# Attendre que MariaDB réponde sur le port 3306
echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    sleep 2
done
# test

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

cd /var/www/html

if [ ! -s "wp-config.php" ]; then

    echo "Preparing WordPress installation..."
    wp core download --allow-root

    echo "Generating wp-config.php file..."
    wp config create --allow-root \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" --skip-check

    echo "Installing WordPress..."
    wp core install --allow-root \
        --url="$DOMAIN_NAME" \
        --title="$WORDPRESS_DB_NAME" \
        --admin_user="$WORDPRESS_ADMIN" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_MAIL"

    echo "Adding a new WordPress user..."
    wp user create "$WORDPRESS_USER" "$WORDPRESS_USER_MAIL" \
        --role=subscriber \
        --user_pass="$WORDPRESS_USER_PASSWORD" \
        --allow-root --path=/var/www/html
else
    echo "WordPress is already set up and ready to use."
fi

echo "Starting de PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F