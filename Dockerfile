FROM php:8.3-apache

# Install Chromium, fonts, git, unzip, and PHP extension dependencies
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-freefont-ttf \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install required sockets extension
RUN docker-php-ext-install sockets

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy application files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Disable conflicting Apache MPM modules and enable prefork
RUN a2dismod mpm_event mpm_worker || true && a2enmod mpm_prefork

# Set write permissions
RUN chmod -R 777 /var/www/html

# Configure Apache to listen on Railway's $PORT dynamically
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

EXPOSE 80

CMD ["apache2-foreground"]
