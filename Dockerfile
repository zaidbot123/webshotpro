FROM php:8.2-apache

# Install Chromium and system dependencies required for headless rendering
RUN apt-get update && apt-get install -y \
    chromium \
    libnss3 \
    libgconf-2-4 \
    libfontconfig1 \
    libxss1 \
    libasound2 \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set Chrome executable environment variable
ENV CHROME_PATH=/usr/bin/chromium

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy project files
COPY . .

# Install PHP packages
RUN composer install --no-dev --optimize-autoloader

EXPOSE 80
