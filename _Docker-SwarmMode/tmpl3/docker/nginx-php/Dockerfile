# FROM composer:2.0.13 as vendor

#COPY composer.json composer.json
#COPY composer.lock composer.lock

# RUN composer install \
#     --ignore-platform-reqs \
#     --no-interaction \
#     --no-plugins \
#     --no-scripts \
#     --prefer-dist

# FROM node:14 as frontend

#RUN mkdir -p /app/public

#COPY package.json webpack.mix.js package.lock /app/
#COPY resources/assets/ /app/resources/assets/

# WORKDIR /app

# RUN npm install && npm production

FROM alpine:3.13.5

# Install packages and remove default server definition
RUN apk --no-cache add \
  curl \
  nginx \
  php8 \
  php8-ctype \
  php8-curl \
  php8-dom \
  php8-fpm \
  php8-gd \
  php8-intl \
  php8-json \
  php8-mbstring \
  php8-mysqli \
  php8-opcache \
  php8-openssl \
  php8-phar \
  php8-session \
  php8-xml \
  php8-xmlreader \
  php8-zlib \
  supervisor \
  && rm /etc/nginx/conf.d/default.conf

# Create symlink so programs depending on `php` still function
RUN ln -s /usr/bin/php8 /usr/bin/php

# Configure nginx
COPY docker/nginx-php/config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY docker/nginx-php/config/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY docker/nginx-php/config/php.ini /etc/php8/conf.d/custom.ini

# Configure supervisord
COPY docker/nginx-php/config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Add application
WORKDIR /var/www/html
COPY --chown=nobody . /var/www/html/
#COPY --chown=nobody --from=vendor /app /var/www/html
#COPY --chown=nobody --from=frontend /app/public/js /var/www/html/public/js
#COPY --chown=nobody --from=frontend /app/public/css /var/www/html/public/css
#COPY --chown=nobody --from=frontend /app/mix-manifest.json /var/www/html/mix-manifest.json

RUN rm -Rf docker

# Expose the port nginx is reachable on
EXPOSE 80

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:80/fpm-ping