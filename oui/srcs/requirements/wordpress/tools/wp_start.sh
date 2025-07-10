# #!/bin/bash
# set -e

# echo "Waiting for MariaDB to be ready..."

# # On attend que MariaDB réponde au ping avec les bons identifiants root (car wp_user peut ne pas exister au début)
# until mysqladmin ping -h"$MYSQL_HOST" -uroot -p"$MYSQL_ROOT_PASSWORD" --silent; do
#     echo "MariaDB is unavailable - sleeping"
#     sleep 2
# done

# echo "MariaDB is up - proceeding"

# # Si wp_user n'existe pas encore, on le crée avec les droits nécessaires
# mysql -h"$MYSQL_HOST" -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%'; FLUSH PRIVILEGES;"

# # Préparer WordPress si pas déjà fait
# if [ ! -f /var/www/html/wp-config.php ]; then
#     echo "Preparing WordPress installation..."

#     # Télécharger WordPress
#     wp core download --path=/var/www/html --allow-root

#     # Créer wp-config.php
#     wp config create \
#         --dbname="$MYSQL_DATABASE" \
#         --dbuser="$MYSQL_USER" \
#         --dbpass="$MYSQL_PASSWORD" \
#         --dbhost="$MYSQL_HOST" \
#         --path=/var/www/html \
#         --allow-root

#     # Installer WordPress
#     wp core install \
#         --url="$DOMAIN_NAME" \
#         --title="My WordPress" \
#         --admin_user="$WP_ADMIN" \
#         --admin_password="$WP_ADMIN_PASSWORD" \
#         --admin_email="$WP_ADMIN_EMAIL" \
#         --path=/var/www/html \
#         --skip-email \
#         --allow-root

#     # Ajouter un utilisateur supplémentaire
#     wp user create "$WP_USER" "$WP_USER_EMAIL" \
#         --user_pass="$WP_USER_PASSWORD" \
#         --role=author \
#         --allow-root
# else
#     echo "WordPress already installed."
# fi

# echo "Starting PHP-FPM..."
# exec php-fpm7.4 -F

# #!/bin/bash
# set -e

# echo "Waiting for MariaDB to be ready..."

# # Attendre que MariaDB soit accessible
# MAX_TRIES=30
# TRIES=0

# while [ $TRIES -lt $MAX_TRIES ]; do
#     if mysqladmin ping -h"$MYSQL_HOST" -uroot -p"$MYSQL_ROOT_PASSWORD" --silent 2>/dev/null; then
#         echo "MariaDB is ready!"
#         break
#     fi
#     echo "MariaDB is unavailable - sleeping (attempt $((TRIES+1))/$MAX_TRIES)"
#     sleep 3
#     TRIES=$((TRIES+1))
# done

# if [ $TRIES -eq $MAX_TRIES ]; then
#     echo "ERROR: MariaDB failed to become ready after $MAX_TRIES attempts"
#     exit 1
# fi

# # Créer l'utilisateur WordPress si nécessaire
# mysql -h"$MYSQL_HOST" -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%'; FLUSH PRIVILEGES;" 2>/dev/null || true

# # Changer vers le répertoire WordPress
# cd /var/www/html

# # Préparer WordPress si pas déjà fait
# if [ ! -f wp-config.php ]; then
#     echo "Preparing WordPress installation..."
    
#     # Nettoyer le répertoire et télécharger WordPress
#     rm -rf *
#     wp core download --allow-root
    
#     # Créer wp-config.php
#     wp config create \
#         --dbname="$MYSQL_DATABASE" \
#         --dbuser="$MYSQL_USER" \
#         --dbpass="$MYSQL_PASSWORD" \
#         --dbhost="$MYSQL_HOST" \
#         --allow-root
    
#     # Attendre que la base soit vraiment prête
#     until wp db check --allow-root; do
#         echo "Waiting for database to be ready..."
#         sleep 2
#     done
    
#     # Installer WordPress
#     wp core install \
#         --url="$DOMAIN_NAME" \
#         --title="My WordPress Site" \
#         --admin_user="$WP_ADMIN" \
#         --admin_password="$WP_ADMIN_PASSWORD" \
#         --admin_email="$WP_ADMIN_EMAIL" \
#         --skip-email \
#         --allow-root
    
#     # Créer un utilisateur supplémentaire
#     wp user create "$WP_USER" "$WP_USER_EMAIL" \
#         --user_pass="$WP_USER_PASSWORD" \
#         --role=author \
#         --allow-root
    
#     echo "WordPress installation completed!"
# else
#     echo "WordPress already installed."
# fi

# # Corriger les permissions
# chown -R www-data:www-data /var/www/html
# chmod -R 755 /var/www/html

# echo "Starting PHP-FPM..."
# exec php-fpm7.4 -F

#!/bin/bash
set -e

echo "Waiting for MariaDB to be ready..."

# Attendre que MariaDB soit accessible
MAX_TRIES=30
TRIES=0

while [ $TRIES -lt $MAX_TRIES ]; do
    if mysqladmin ping -h"$MYSQL_HOST" -uroot -p"$MYSQL_ROOT_PASSWORD" --silent 2>/dev/null; then
        echo "MariaDB is ready!"
        break
    fi
    echo "MariaDB is unavailable - sleeping (attempt $((TRIES+1))/$MAX_TRIES)"
    sleep 3
    TRIES=$((TRIES+1))
done

if [ $TRIES -eq $MAX_TRIES ]; then
    echo "ERROR: MariaDB failed to become ready after $MAX_TRIES attempts"
    exit 1
fi

# Créer l'utilisateur WordPress si nécessaire
mysql -h"$MYSQL_HOST" -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%'; FLUSH PRIVILEGES;" 2>/dev/null || true

# Changer vers le répertoire WordPress
cd /var/www/html

# Préparer WordPress si pas déjà fait
if [ ! -f wp-config.php ]; then
    echo "Preparing WordPress installation..."
    
    # Nettoyer le répertoire et télécharger WordPress
    rm -rf *
    wp core download --allow-root
    
    # Créer wp-config.php
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$MYSQL_HOST" \
        --allow-root
    
    # Attendre que la base soit vraiment prête
    until wp db check --allow-root; do
        echo "Waiting for database to be ready..."
        sleep 2
    done
    
    # Installer WordPress
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="My WordPress Site" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root
    
    # Créer un utilisateur supplémentaire
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root
    
    echo "WordPress installation completed!"
else
    echo "WordPress already installed."
fi

# Corriger les permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
