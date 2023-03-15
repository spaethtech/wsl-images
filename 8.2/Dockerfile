ARG PHP_VERSION=8.2

FROM spaethtech/wsl-php:base

ENV PHPIZE_DEPS=${PHPIZE_DEPS:-"autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c"}
ENV XDEBUG_VERSION=3.2.0

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago

RUN apt-get install -y php8.2 php8.2-xdebug

# TODO: Install any additional PHP modules here...

