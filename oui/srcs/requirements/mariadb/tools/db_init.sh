#!/bin/bash

mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

# Initialisation seulement si la base n'existe pas encore
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation de la base de données..."

    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    mysqld_safe &
    # Attendre que le serveur MariaDB soit prêt
    while ! mysqladmin ping --silent; do
        sleep 1
    done

    mysql -u root <<-EOF
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOF

    # Arrêter proprement le serveur temporaire
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
fi

# Lancer MariaDB normalement
exec mysqld_safe
