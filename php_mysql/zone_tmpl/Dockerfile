FROM php:7.2-fpm
WORKDIR "/var/www"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip

RUN docker-php-ext-install pdo pdo_mysql
RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

EXPOSE 9000

CMD ["php-fpm"]
