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

# Fix Apache MPM conflict by keeping only prefork
RUN a2dismod mpm_event mpm_worker || true && a2enmod mpm_prefork

# Set folder permissions
RUN chmod -R 777 /var/www/html

EXPOSE 80

# Configure port at container start and launch Apache
CMD ["sh", "-c", "sed -i 's/80/'\"${PORT:-80}\"'/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf && exec apache2-foreground"]
