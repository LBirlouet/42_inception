#!/bin/bash

mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation de la base de données..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    mysqld_safe &
    while ! mysqladmin ping --silent; do
        sleep 1
    done

    mysql -u root <<-EOF
        CREATE DATABASE IF NOT EXISTS ${SQL_DB};
        CREATE USER IF NOT EXISTS '${SQL_USR}'@'%' IDENTIFIED BY '${SQL_USR_PSW}';
        GRANT ALL PRIVILEGES ON ${SQL_DB}.* TO '${SQL_USR}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PSW}';
        FLUSH PRIVILEGES;
EOF

    mysqladmin -u root -p"${SQL_ROOT_PSW}" shutdown
fi

exec mysqld_safe