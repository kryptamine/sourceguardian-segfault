FROM php:8.0-fpm-alpine as sourceguardian-loader

RUN curl https://www.sourceguardian.com/loaders/download/loaders.linux-x86_64.tar.gz --output /loader.tar.gz && \
    tar -xzf /loader.tar.gz -C /

FROM php:8.0-fpm-alpine

WORKDIR /var/www/backend

ADD . /var/www/backend

RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        libtool \
        libxml2-dev \
        postgresql-dev \
        oniguruma-dev \
    && apk add --no-cache \
        git \
        bash \
        gettext \
        libtool \
        postgresql-libs \
        libintl \
        icu \
        icu-dev \
        libzip-dev \
        cdrkit \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install \
        iconv \
        mbstring \
        pdo_pgsql \
        pcntl \
        tokenizer \
        xml \
        zip \
        intl \
        bcmath \
        sockets \
    && curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer \
    && apk del -f .build-deps

ARG LOADER_EXTENSION=ixed.8.0.lin

COPY --from=sourceguardian-loader /$LOADER_EXTENSION /usr/local/lib/php/extensions/$LOADER_EXTENSION
RUN echo "zend_extension=/usr/local/lib/php/extensions/$LOADER_EXTENSION" > /usr/local/etc/php/conf.d/00_sourceguardian.ini && \
    echo "memory_limit = 256M" > /usr/local/etc/php/conf.d/00_memory_limit.ini

ENTRYPOINT php /var/www/backend/vendor/phpunit/phpunit/phpunit
