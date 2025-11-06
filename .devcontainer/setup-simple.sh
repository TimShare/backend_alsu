#!/bin/bash
set -e

echo "🚀 Настройка Laravel окружения..."

# Установка PHP расширений
echo "📦 Установка PHP расширений..."
sudo apt-get update
sudo apt-get install -y libpng-dev libonig-dev libxml2-dev libzip-dev default-mysql-client
sudo docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Установка Composer
echo "📦 Установка Composer..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Установка зависимостей
echo "📦 Установка зависимостей..."
composer install --no-interaction --prefer-dist

# Создание .env
echo "📝 Создание .env файла..."
if [ ! -f .env ]; then
    cp .env.codespaces .env
fi

# Генерация ключа
echo "🔑 Генерация APP_KEY..."
php artisan key:generate --no-interaction

# Создание директорий
echo "📁 Создание необходимых директорий..."
mkdir -p storage/framework/{sessions,views,cache}
mkdir -p storage/logs
mkdir -p bootstrap/cache
chmod -R 775 storage bootstrap/cache

echo "✅ Настройка завершена!"
echo ""
echo "📌 Для запуска приложения выполните:"
echo "   php artisan serve --host=0.0.0.0 --port=8000"
echo ""
echo "📌 MySQL не установлен. Для работы с БД используйте:"
echo "   docker run -d --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root_password -e MYSQL_DATABASE=zelen_restaurant -e MYSQL_USER=zelen_user -e MYSQL_PASSWORD=zelen_password mysql:8.0"
