ARG phpVersion="8-fpm"
FROM php:${phpVersion}
WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    libmcrypt-dev \
    libxml2-dev \
    libssl-dev \
    libsqlite3-dev \
    zlib1g-dev \
    libcurl4-gnutls-dev \
    libpng-dev \
    libwebp-dev \
    libjpeg-dev \
    libonig-dev \
    libsodium-dev \
    libargon2-dev \
    libxslt1-dev \
    libzip-dev \
    libxslt-dev \
    unzip \
    ffmpeg \
    mc \
    nano \
    htop \
    sendmail \
    supervisor

RUN docker-php-ext-install mbstring mysqli pdo_mysql gd zip calendar exif gettext \
    pcntl shmop soap sockets sysvmsg sysvsem sysvshm xsl opcache bcmath intl

RUN pecl install apcu igbinary redis \
    && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini igbinary redis

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ARG user
ARG uid

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /var/www 
RUN mkdir -p /home/$user/.composer && \
chown -R $user:www-data /home/$user && \
chown -R $user:www-data /var/www 

COPY ./php/* /usr/local/etc/php-fpm.d/

COPY ./bash.bashrc /etc/bash.bashrc
RUN apt-get install net-tools iputils-ping bash-completion -y

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
COPY ./supervisord.conf /etc/supervisor/supervisord.conf
ARG port=9000
RUN echo "$user:docker" | chpasswd
RUN sed -i "s/USERNAME/${user}/g" /etc/supervisor/supervisord.conf
RUN sed -i "s/9000/${port}/g" /etc/supervisor/supervisord.conf
RUN sed -i "s/900/php/g" /etc/supervisor/supervisord.conf
RUN sed -i "s/USERNAME/${user}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/USERNAME/${user}/g" /usr/local/etc/php-fpm.d/zz-docker.conf
RUN sed -i "s/9000/${port}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/9000/${port}/g" /usr/local/etc/php-fpm.d/zz-docker.conf
COPY ./bash/* /usr/bin/

EXPOSE ${port}
CMD [ "runonce" ]
#CMD ["php-fpm", "-R"]