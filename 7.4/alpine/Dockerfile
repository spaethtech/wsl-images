ARG PHP_VERSION
ARG XDEBUG_VERSION

FROM php:${PHP_VERSION:-7.4.27}-alpine

# WSL2 & Docker
ADD wsl.conf /etc/wsl.conf

# Docker Integration (WSL2)
ADD docker.sh /etc/profile.d/docker.sh

# Shell Colors
ADD color_prompt.sh /etc/profile.d/color_prompt.sh
RUN rm /etc/profile.d/color_prompt.sh.disabled

# Composer
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENV XDEBUG_VERSION=${XDEBUG_VERSION:-3.1.6}

# Xdebug
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
 && pecl install xdebug-$XDEBUG_VERSION \
 && docker-php-ext-enable xdebug \
 && apk del -f .build-deps

ADD ../xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# TODO: Install any additional PHP modules here...
