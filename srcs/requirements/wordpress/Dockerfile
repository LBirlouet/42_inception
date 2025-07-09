# FROM debian:bullseye

# RUN apt-get update -y && \
#     apt-get upgrade -y && \
#     apt-get install -y php php-fpm php-mysql mariadb-client curl wget && \
#     curl -sS https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
#     chmod +x /usr/local/bin/wp && \
#     mkdir -p /run/php

# WORKDIR /var/www/html

# RUN wget https://wordpress.org/latest.tar.gz && \
#     tar -xzf latest.tar.gz && \
#     rm latest.tar.gz

# COPY conf/wordpress.conf /etc/php/7.4/fpm/pool.d/
# COPY tools/wp_start.sh /usr/local/bin/

# RUN chmod +x /usr/local/bin/wp_start.sh

# EXPOSE 9000

# ENTRYPOINT ["/usr/local/bin/wp_start.sh"]
FROM debian:bullseye

RUN apt-get update -y && apt-get install -y \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-cli \
    php7.4-curl \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-zip \
    php7.4-gd \
    mariadb-client \
    curl \
    wget \
    unzip \
    vim \
    less \
    gnupg \
    lsb-release \
    ca-certificates \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    git \
    && apt-get clean

RUN sed -i "s|listen = .*|listen = 0.0.0.0:9000|" /etc/php/7.4/fpm/pool.d/www.conf

RUN curl -0 https:raw//githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY tools/wp_start.sh /usr/local/bin/wp_start.sh
RUN chmod +x /usr/local/bin/wp_start.sh

EXPOSE 9000

CMD ["/usr/local/bin/wp_start.sh"]