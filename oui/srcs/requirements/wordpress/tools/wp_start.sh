#!/bin/bash
set -e

echo "=== WP-START.SH ==="
echo "Waiting for MariaDB to be ready..."
echo "Using host: $MYSQL_HOST"
echo "Using user: $MYSQL_USER"
echo "Database: $MYSQL_DATABASE"

# Vérifie que le hostname DNS de MariaDB est résolu
getent hosts "$MYSQL_HOST" || {
    echo "ERROR: Hostname '$MYSQL_HOST' could not be resolved!"
    exit 1
}

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
echo "Ensuring WordPress DB user exists..."
mysql -h"$MYSQL_HOST" -uroot -p"$MYSQL_ROOT_PASSWORD" <<EOF || {
    echo "ERROR: Failed to create WordPress DB user or grant privileges."
    exit 1
}
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'wordpress.srcs_inception' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'wordpress.srcs_inception';
FLUSH PRIVILEGES;
EOF

# Changer vers le répertoire WordPress
cd /var/www/html

# Préparer WordPress si pas déjà fait
if [ ! -f wp-config.php ]; then
    echo "Preparing WordPress installation..."
    
    rm -rf *
    wp core download --allow-root

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

    wp core install \
        --url="$DOMAIN_NAME" \
        --title="My WordPress Site" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

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
