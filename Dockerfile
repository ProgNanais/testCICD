# syntax=docker/dockerfile:1

FROM php:8.3-cli-alpine

# Installations minimales (intl, mbstring si besoin)
RUN docker-php-ext-install opcache

WORKDIR /app
COPY . /app

# Installer composer dans l'image pour simplifier (prod: on ferait un stage builder)
RUN php -r "copy('https://getcomposer.org/installer','composer-setup.php');" \
 && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && rm composer-setup.php

# Installer dépendances sans dev pour l'image (ici petit projet, c'est ok)
RUN composer install --no-interaction --no-progress --prefer-dist

# Lancer un petit serveur interne PHP sur 0.0.0.0:8080
EXPOSE 8080
CMD ["php", "-S", "0.0.0.0:8080", "-t", "public"]
