FROM debian:bullseye
RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get install -y curl php7.4 php7.4-fpm php7.4-mysql mariadb-client && \
	curl -sS https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
	chmod +x /usr/local/bin/wp &&\
	mkdir -p run/php
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/
COPY ./tools/start_wp.sh /usr/local/bin/start_wp.sh
RUN chmod +x /usr/local/bin/start_wp.sh
EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/start_wp.sh"]