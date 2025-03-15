FROM serversideup/php:8.2-fpm-apache

# Switch to root user for installation
USER root

# Install dependencies, including FFmpeg
RUN apt-get update && apt-get install -y \
    imagemagick \
    libmagickwand-dev \
    libjpeg-dev \
    libpng-dev \
    libwebp-dev \
    libfreetype6-dev \
    ffmpeg \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd exif \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && chown -R www-data:www-data /var/www/html

# Ensure `exec()` is enabled by modifying PHP configuration
RUN echo "disable_functions=" > /usr/local/etc/php/conf.d/custom.ini

# Switch back to the default web user
USER www-data
