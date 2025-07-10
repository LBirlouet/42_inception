FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld

COPY c./onf/mdb.cnf /etc/mysql/mariadb.conf.d/mdb.cnf

COPY ./tools/db_init.sh /usr/local/bin/db_init.sh

RUN chmod +x /usr/local/bin/db_init.sh && \
	sed -i 's/\r$//' /usr/local/bin/db_init.sh 

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/db_init.sh"]