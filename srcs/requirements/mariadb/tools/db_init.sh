#!/bin/bash

# mkdir -p /var/run/mysqld
# chown -R mysql:mysql /var/run/mysqld

# if [ ! -d "/var/lib/mysql/mysql" ]; then
#     echo "Initialisation de la base de données..."
#     mysql_install_db --user=mysql --datadir=/var/lib/mysql

#     mysqld_safe &
#     while ! mysqladmin ping --silent; do
#         sleep 1
#     done

#     mysql -u root <<-EOF
#         CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
#         CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
#         GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
#         ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
#         FLUSH PRIVILEGES;
# EOF

#     mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
# fi

# exec mysqld_safe

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