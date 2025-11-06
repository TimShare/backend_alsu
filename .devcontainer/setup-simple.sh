#!/bin/bash
set -e

echo "🚀 Настройка Laravel окружения..."

# Установка зависимостей
echo "📦 Установка Composer зависимостей..."
composer install --no-interaction --prefer-dist || {
    echo "⚠️ Composer install failed, возможно нужны PHP расширения"
    echo "Попробуем установить необходимые пакеты..."
    sudo apt-get update
    sudo apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev libzip-dev
    composer install --no-interaction --prefer-dist
}

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
echo "🚀 Запуск Laravel сервера..."
echo "Выполните в терминале:"
echo "  php artisan serve --host=0.0.0.0 --port=8000"
