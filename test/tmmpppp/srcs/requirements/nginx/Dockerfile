FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl

COPY ./conf/nginx.conf /etc/nginx/sites-available/default

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/fvastena.key -out /etc/nginx/ssl/fvastena.crt -subj "/CN=fvastena"

RUN mkdir -p /var/run/nginx

RUN chmod 755 /var/www/html && \
	chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]