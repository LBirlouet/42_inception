# #!/bin/bash

# # mkdir -p /var/run/mysqld
# # chown -R mysql:mysql /var/run/mysqld

# # if [ ! -d "/var/lib/mysql/mysql" ]; then
# #     echo "Initialisation de la base de données..."
# #     mysql_install_db --user=mysql --datadir=/var/lib/mysql

# #     mysqld_safe &
# #     while ! mysqladmin ping --silent; do
# #         sleep 1
# #     done

# #     mysql -u root <<-EOF
# #         CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
# #         CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# #         GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
# #         ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
# #         FLUSH PRIVILEGES;
# # EOF

# #     mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
# # fi

# # exec mysqld_safe

# mkdir -p /var/run/mysqld
# chown -R mysql:mysql /var/run/mysqld
# mysqld_safe &
# while ! mysqladmin ping --silent; do
#     sleep 1
# done
# mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOF
# CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
# CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
# FLUSH PRIVILEGES;
# EOF
# mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
# exec mysqld_safe


# #!/bin/bash

# mkdir -p /var/run/mysqld
# chown -R mysql:mysql /var/run/mysqld

# # Initialisation seulement si la base n'existe pas encore
# if [ ! -d "/var/lib/mysql/mysql" ]; then
#     echo "Initialisation de la base de données..."

#     mysql_install_db --user=mysql --datadir=/var/lib/mysql

#     mysqld_safe &
#     # Attendre que le serveur MariaDB soit prêt
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

#     # Arrêter proprement le serveur temporaire
#     mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
# fi

# # Lancer MariaDB normalement
# exec mysqld_safe

# #!/bin/bash
# set -e

# mkdir -p /var/run/mysqld
# chown -R mysql:mysql /var/run/mysqld
# chown -R mysql:mysql /var/lib/mysql

# # Initialisation seulement si la base n'existe pas encore
# if [ ! -d "/var/lib/mysql/mysql" ]; then
#     echo "Initialisation de la base de données..."
    
#     mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
#     # Démarrer MariaDB temporairement pour la configuration
#     mysqld_safe --user=mysql &
#     MYSQL_PID=$!
    
#     # Attendre que le serveur soit prêt
#     while ! mysqladmin ping --silent; do
#         echo "Waiting for MariaDB to start..."
#         sleep 2
#     done
    
#     # Configuration de la base
#     mysql -u root <<-EOF
#         CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
#         CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
#         GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
#         ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
#         DELETE FROM mysql.user WHERE User='';
#         DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
#         DROP DATABASE IF EXISTS test;
#         DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
#         FLUSH PRIVILEGES;
# EOF
    
#     # Arrêter proprement le serveur temporaire
#     mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
#     wait $MYSQL_PID
    
#     echo "Base de données initialisée avec succès"
# fi

# echo "Démarrage de MariaDB..."
# exec mysqld_safe --user=mysql