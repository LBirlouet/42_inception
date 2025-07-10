#!/bin/bash

mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
mysqld_safe &
while ! mysqladmin ping --silent; do
    sleep 1
done
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
exec mysqld_safe