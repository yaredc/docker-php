FROM php:7.3-fpm-alpine

COPY ./.docker/dev/php.docker-watch.sh /usr/local/bin/docker-watch

RUN apk add --no-cache --virtual .deps autoconf tzdata build-base libzip-dev postgresql-dev \
            libxml2-dev libxslt-dev libpng-dev zlib-dev freetype-dev jpeg-dev icu-dev &&\
    pecl install xdebug-2.7.2 &&\
    docker-php-ext-install zip xml xsl pgsql mbstring json intl gd pdo pdo_pgsql iconv &&\
    docker-php-ext-enable xdebug &&\
    echo 'date.timezone="Europe/Berlin"' >> "${PHP_INI_DIR}"/php.ini &&\
    echo "xdebug.remote_port=9000"       >> "${PHP_INI_DIR}"/php.ini &&\
    echo "memory_limit=-1"               >> "${PHP_INI_DIR}"/php.ini &&\
    echo "php_flag[display_errors]=on"                >> /usr/local/etc/php-fpm.conf &&\
    echo "php_admin_flag[log_errors]=on"              >> /usr/local/etc/php-fpm.conf &&\
    echo "php_admin_value[error_log]=/proc/self/fd/2" >> /usr/local/etc/php-fpm.conf &&\
    echo "php_admin_value[error_reporting]=E_ALL"     >> /usr/local/etc/php-fpm.conf &&\
    echo "php_admin_value[display_startup_errors]=on" >> /usr/local/etc/php-fpm.conf &&\
    cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime &&\
    echo "Europe/Berlin" > /etc/timezone &&\
    curl -s https://getcomposer.org/composer.phar > /bin/composer &&\
    chmod a+x /bin/composer &&\
    ln -s /bin/composer /usr/local/bin/composer &&\
    ln -s /bin/composer /usr/local/composer &&\
    ln -s /bin/composer /usr/bin/composer &&\
    curl -s https://www.phing.info/get/phing-latest.phar > /bin/phing &&\
    chmod a+x /bin/phing &&\
    ln -s /bin/phing /usr/local/bin/phing &&\
    ln -s /bin/phing /usr/local/phing &&\
    ln -s /bin/phing /usr/bin/phing &&\
    apk del .deps &&\
    apk add --no-cache libzip postgresql libxml2 libxslt libpng zlib freetype jpeg icu &&\
    chown -R www-data:www-data /var/www/html &&\
    chmod a+x /usr/local/bin/docker-watch &&\
    su www-data -s /bin/sh -c "composer global require fxp/composer-asset-plugin"

USER www-data

CMD ["/bin/sh", "-c", "crond & docker-watch & php-fpm"]
