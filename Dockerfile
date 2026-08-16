FROM php:8.3-apache

# Install Chromium, fonts, git, and unzip tools required by Composer
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-freefont-ttf \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Composer from official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy project files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Disable worker/event MPMs and enable prefork for PHP
RUN a2dismod mpm_event mpm_worker || true && a2enmod mpm_prefork

# Grant directory permissions for saving screenshot outputs
RUN chmod -R 777 /var/www/html

# Dynamically bind Apache port to Railway's $PORT environment variable
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

EXPOSE 80
