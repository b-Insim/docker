FROM php:7.3-apache

Maintainer "Boleyn"

RUN apt-get update -yq \
    && apt-get install curl wget gnupg -yq \
    && curl -sL https://deb.nodesource.com/setup_10.x \
    && apt-get install nodejs -y \
    && apt-get clean -y

# installation PHP extension et configuration PHP-GD
RUN buildDeps=" \
        default-libmysqlclient-dev \
        libbz2-dev \
        libmemcached-dev \
        libsas12-dev \
    " \
    runtimeDeps=" \
        git \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libldap2-dev \
        libmemcachedutil2 \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libzip-dev \
    " \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $builDeps $runtimeDeps \
    && docker-php-ext-install bcmath calendar iconv intl mbstring mysqli opcache pdo_mysql pgsql soap \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

ENV DOLI_VERSION 10.0.3
#RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install {your- pkgs} 

#ADD . /app
#WORKDIR /app
RUN wget -q https://github.com/Dolibarr/dolibarr/archive/${DOLI_VERSION}.tar.gz \
    && tar xf ${DOLI_VERSION}.tar.gz \
    && mv dolibarr-${DOLI_VERSION}/htdocs/* /var/www/html/ \
    && rm -rf dolibarr-${DOLI_VERSION} ${DOLI_VERSION}.tar.gz

WORKDIR /var/www/html

# Gestion des droits et configuration 

RUN chmod -R 755 /var/www/html/
RUN chown -R www-data.www-data . \
 && touch /var/www/html/conf/conf.php \
 && chown  www-data /var/www/html/conf/conf.php \
 && mkdir -p /var/lib/dolibarr/documents \
 && chown www-data /var/lib/dolibarr/documents
  

      #&& mv dolibarr-${DOLI_VERSION}/htdocs/* /var/www/html \

#EXPOSE 8080
VOLUME /var/www/html /var/www/html/conf /var/www/html/documents

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
#CMD ["php:7.3-apache"]
