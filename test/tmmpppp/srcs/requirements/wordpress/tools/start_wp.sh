#!/bin/bash

echo "En attente de la base de données..."
sleep 10
echo "Base de données accessible."

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

cd /var/www/html

if [ ! -s "wp-config.php" ]
then
    echo "Téléchargement de Wordpress..."
	wp core download --allow-root

	echo "Création du fichier wp-config.php..."
	wp config create --allow-root --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb --skip-check

	echo "Installation de WordPress..."
	wp core install --allow-root --url=$WP_URL --title=$WP_TITLE --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL

	echo "Création d'un nouvel utilisateur"
	wp user create "$WP_USER" "$WP_USER_EMAIL" --role=subscriber --user_pass="$WP_USER_PASSWORD" --allow-root --path=/var/www/html
else
    echo "WordPress déjà installé."
fi

echo "Démarrage de PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F