FROM php:7.1-apache

RUN pecl update-channels

RUN docker-php-ext-install pdo pdo_mysql bcmath sockets mysqli opcache && docker-php-ext-enable opcache

RUN pecl install apcu && docker-php-ext-enable apcu

RUN apt-get update && apt-get install -y libcurl4-openssl-dev libxml2-dev

RUN docker-php-ext-install curl json xml && docker-php-ext-enable curl json xml

RUN apt-get -y install gcc make autoconf libc-dev pkg-config \
    && apt-get -y install libyaml-dev \
    && pecl channel-update pecl.php.net \
    && pecl install yaml && docker-php-ext-enable yaml

RUN apt-get install -y libpng-dev \
    && docker-php-ext-install gd

RUN apt-get install -y zip \
    && docker-php-ext-install zip

RUN a2enmod rewrite

WORKDIR /usr/local/etc/php/conf.d/

COPY docker/config/apache/php.ini .

RUN mkdir -p /var/log/php/ && touch /var/log/php/php_error.log && chown -R www-data:www-data /var/log/php/php_error.log

WORKDIR /var/www/html/

RUN chown -R www-data:www-data /var/www/html/

COPY ./public/ .

EXPOSE 9000