FROM php:8.3-apache

# Install Chromium, fonts, git, unzip, and PHP extension dependencies
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-freefont-ttf \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install required sockets extension for chrome-php
RUN docker-php-ext-install sockets

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy application files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Completely remove all enabled MPM symlinks to eliminate the conflict, then enable prefork
RUN rm -f /etc/apache2/mods-enabled/mpm_*.load /etc/apache2/mods-enabled/mpm_*.conf \
    && a2enmod mpm_prefork

# Set write permissions
RUN chmod -R 777 /var/www/html

EXPOSE 80

# Bind port dynamically at startup and run Apache
CMD ["sh", "-c", "sed -i 's/80/'\"${PORT:-80}\"'/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf && exec apache2-foreground"]
