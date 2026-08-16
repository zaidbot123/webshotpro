FROM php:8.3-apache

# Install Chromium and basic system web layout engines
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-freefont-ttf \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Copy all local project assets into the server
COPY . .

# Grant write access to the directory so PHP can save image files locally
RUN chmod -R 777 /var/www/html

# Expose web network pipelines
EXPOSE 80
