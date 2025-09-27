FROM php:8.3-fpm

# deps + PHP ext
RUN apt-get update && apt-get install -y --no-install-recommends \
    git unzip libpq-dev libzip-dev libxml2-dev libonig-dev pkg-config nginx supervisor curl \
 && docker-php-ext-install -j"$(nproc)" pdo pdo_mysql pdo_pgsql zip mbstring \
 && rm -rf /var/lib/apt/lists/*

 RUN rm -f /etc/nginx/sites-enabled/default /etc/nginx/conf.d/default.conf \
 && mkdir -p /var/run/nginx /var/cache/nginx /var/log/nginx
 
# composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# nginx
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# supervisord
COPY docker/app/supervisord.conf /etc/supervisor/supervisord.conf

WORKDIR /var/www/html

# 1) Copy composer manifests first (enable layer cache)
COPY app/composer.json app/composer.lock /var/www/html/


WORKDIR /var/www/html

COPY app/ /var/www/html/

RUN cp .env.example .env || true \
 && php artisan key:generate --force

RUN COMPOSER_ALLOW_SUPERUSER=1 composer install \
    --no-dev --prefer-dist --no-progress --no-interaction --optimize-autoloader


# 2) Install PHP deps (no dev)
RUN composer install --no-dev --prefer-dist --no-progress --no-interaction --optimize-autoloader

# 4) Permissions (ignore if missing locally)
RUN chown -R www-data:www-data storage bootstrap/cache || true


# healthcheck за ALB / for local test
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD curl -fsS http://localhost/up || exit 1

EXPOSE 80

# start  nginx + php-fpm by supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]