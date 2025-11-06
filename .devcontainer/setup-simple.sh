#!/bin/bash
set -e

echo "🚀 Настройка Laravel окружения..."

# Проверка что composer установлен
if ! command -v composer &> /dev/null; then
    echo "📦 Установка Composer..."
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
fi

# Установка зависимостей
echo "📦 Установка зависимостей..."
composer install --no-interaction --prefer-dist --ignore-platform-reqs

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
echo "🚀 Запуск Laravel сервера в фоне..."
nohup php artisan serve --host=0.0.0.0 --port=8000 > /tmp/laravel.log 2>&1 &
echo "✅ Сервер запущен на порту 8000"
echo ""
echo "📌 Логи сервера: tail -f /tmp/laravel.log"
