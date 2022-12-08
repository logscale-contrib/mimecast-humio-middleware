FROM php:7.2.34-cli-buster as composer

RUN cd /tmp;\
    apt-get update ;\
    apt -y install zlib1g zlib1g-dev libzip4 libzip-dev;\
    docker-php-ext-configure zip --with-libzip ;\
    docker-php-ext-install zip ;\    
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" ;\
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer ;\
    php -r "unlink('composer-setup.php');"

RUN mkdir /app;mkdir /work
COPY composer.* /app/
COPY bin /app/
COPY src /app/
RUN cd /app;\
    COMPOSER_ALLOW_SUPERUSER=1 composer install

FROM php:7.2.34-cli-buster 

COPY --from=composer /app /app
# RUN touch /work/checkpoint.txt
# RUN touch /work/timestamp_checkpoint.txt


# FROM php:7.2.34-cli-alpine3.12
