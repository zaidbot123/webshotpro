FROM php:8.3-apache

# Install Chromium, fonts, git, unzip, and sockets dependencies
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-freefont-ttf \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install required PHP extension
RUN docker-php-ext-install sockets

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy project files
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Fix Apache MPM conflict
RUN a2dismod mpm_event mpm_worker || true && a2enmod mpm_prefork

# Grant directory permissions
RUN chmod -R 777 /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
