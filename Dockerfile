FROM composer:1.9.3 as vendor


WORKDIR /tmp/

COPY composer.json composer.json
COPY composer.lock composer.lock


RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist


FROM php:7.2-apache-stretch

COPY index.php /var/www/html/index.php
COPY --from=vendor /tmp/vendor/ /var/www/html/vendor/

# copy composer.json and composer.lock
# to make sure trivy can scan them
COPY --from=vendor /tmp/composer.json /manifest/composer.json
COPY --from=vendor /tmp/composer.lock /manifest/composer.lock
