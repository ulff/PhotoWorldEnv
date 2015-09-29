FROM php:5.6-apache

RUN apt-get update \
    && apt-get install -y git libssl-dev zlib1g-dev libicu-dev g++ \
    && pecl install mongo \
    && echo extension=mongo.so > /usr/local/etc/php/conf.d/mongo.ini \
    && pecl install xdebug \
    && echo zend_extension=xdebug.so > /usr/local/etc/php/conf.d/xdebug.ini \
    && pecl install apcu-beta \
    && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini \
    && docker-php-ext-install zip mbstring intl \
    && apt-get install -y libmysqlclient15-dev \
    && apt-get install -y php5-mysql \
    && apt-get install -y php5-gd

RUN cd /var/www \
    && pecl download pdo_mysql
RUN cd /var/www \
    && tar xzf PDO_MYSQL-1.0.2.tgz
RUN cd /var/www/PDO_MYSQL-1.0.2 \
    && phpize \
    && ./configure \
    && sed -i -e"s/\#include <mysql.h>/\#include <\/usr\/include\/mysql\/mysql.h>/" php_pdo_mysql_int.h \
    && sed -i -e"s/\#include <mysqld_error.h>/\#include <\/usr\/include\/mysql\/mysqld_error.h>/" mysql_driver.c \
    && make \
    && make install

ADD docker/vhost.conf /etc/apache2/sites-enabled/000-default.conf
ADD docker/php.ini /usr/local/etc/php/php.ini

RUN a2enmod rewrite

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/bin/composer

WORKDIR /var/www
