FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    && apt-get install -y mariadb-server \

COPY COPY conf/mdb.cnf /etc/mysql/mariadb.conf.d/mdb.cnf
COPY tools/db_init.sh /usr/local/bin/db_init.sh

RUN chmod +x /usr/local/bin/db_initt.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mariadb_start.sh"]