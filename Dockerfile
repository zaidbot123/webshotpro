FROM php:8.3-fpm

# Install Nginx, Chromium, fonts, git, unzip, and PHP extension dependencies
RUN apt-get update && apt-get install -y \
    nginx \
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

# Set directory permissions
RUN chmod -R 777 /var/www/html

# Configure Nginx to proxy PHP and handle dynamic $PORT
RUN echo 'server {\n\
    listen ${PORT};\n\
    root /var/www/html;\n\
    index index.php index.html;\n\
    location / {\n\
        try_files $uri $uri/ /index.php?$query_string;\n\
    }\n\
    location ~ \.php$ {\n\
        fastcgi_pass 127.0.0.1:9000;\n\
        fastcgi_index index.php;\n\
        include fastcgi_params;\n\
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;\n\
    }\n\
}' > /etc/nginx/sites-available/default

EXPOSE 80

# Substitute $PORT into Nginx config at boot, start PHP-FPM, and run Nginx
CMD ["sh", "-c", "envsubst '$$PORT' < /etc/nginx/sites-available/default > /etc/nginx/sites-enabled/default && php-fpm -D && nginx -g 'daemon off;'"]
