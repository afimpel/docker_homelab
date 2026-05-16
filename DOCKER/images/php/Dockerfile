ARG phpVersion="8-fpm"
FROM php:${phpVersion}
WORKDIR /var/www
COPY ./bash/* /usr/bin/
RUN get-release

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
    libavif-dev \
    libxpm-dev \
    libonig-dev \
    libsodium-dev \
    libargon2-dev \
    libxslt1-dev \
    libfreetype6-dev \
    libicu-dev \
    libzip-dev \
    libxslt-dev \
    unzip \
    ffmpeg \
    mc \
    nano \
    htop \
    sendmail \
    supervisor

RUN docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype --with-xpm
RUN docker-php-ext-install mbstring mysqli pdo_mysql gd zip calendar gettext
RUN docker-php-ext-install exif pcntl shmop soap sockets 
RUN docker-php-ext-install bcmath intl pdo
RUN docker-php-ext-install sysvmsg sysvsem sysvshm xsl 

RUN pecl install apcu igbinary redis
RUN docker-php-ext-enable igbinary
RUN docker-php-ext-enable redis
RUN docker-php-ext-enable apcu

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ARG user
ARG uid
RUN apt-get install net-tools iputils-ping bash-completion ca-certificates iproute2 -y

# Create system user to run Composer and Artisan Commands
RUN addgroup ${user}-1000
RUN addgroup ${user}-1001
RUN useradd -g www-data -G root,${user}-1000,${user}-1001 -u $uid -d /home/$user $user
RUN mkdir -p /var/www 
RUN mkdir -p /home/$user/.composer && \
    mkdir -p /home/$user/.config && \
    chown -R $user:www-data /home/$user && \
    chown -R $user:www-data /var/www 

COPY ./php/* /usr/local/etc/php-fpm.d/

COPY ./bash.bashrc /etc/bash.bashrc
COPY ./root.bashrc /root/.bashrc

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Supervisor
COPY ./supervisord.conf /etc/supervisor/supervisord.conf
RUN mkdir -p /var/log/supervisor /var/run

ARG port=9000
RUN echo "$user:docker" | chpasswd

# Tus reemplazos tal cual
RUN sed -i "s/USERNAME/${user}/g" /etc/supervisor/supervisord.conf
RUN sed -i "s/9000/${port}/g" /etc/supervisor/supervisord.conf
RUN sed -i "s/900/php/g" /etc/supervisor/supervisord.conf
RUN sed -i "s/USERNAME/${user}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/USERNAME/${user}/g" /usr/local/etc/php-fpm.d/zz-docker.conf
RUN sed -i "s/9000/${port}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/9000/${port}/g" /usr/local/etc/php-fpm.d/zz-docker.conf

EXPOSE ${port}
CMD [ "runonce" ]