FROM php:8.3-fpm

RUN apt-get update && apt-get install -y --no-install-recommends \
    git unzip libpq-dev libzip-dev libxml2-dev libonig-dev pkg-config \
 && docker-php-ext-install -j"$(nproc)" pdo pdo_mysql pdo_pgsql zip mbstring \
 && rm -rf /var/lib/apt/lists/*


COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
