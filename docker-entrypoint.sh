#!/bin/bash
set -e

echo "🚀 Запуск Docker entrypoint скрипта..."

# Ждем MySQL
echo "⏳ Ожидание MySQL..."
until mysql -h ${DB_HOST:-mysql} -u ${DB_USERNAME:-zelen_user} -p${DB_PASSWORD:-zelen_password} -e "SELECT 1" &> /dev/null
do
    echo "MySQL еще не готов, ждем..."
    sleep 2
done

echo "✅ MySQL готов!"

# Копируем .env если его нет
if [ ! -f .env ]; then
    echo "📄 Копирование .env.example в .env..."
    cp .env.example .env
fi

# Генерируем APP_KEY если его нет
if ! grep -q "base64" .env; then
    echo "🔑 Генерация APP_KEY..."
    php artisan key:generate --no-interaction
fi

# Устанавливаем права
echo "📁 Настройка прав доступа..."
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# Выполняем миграции
echo "🗄️ Выполнение миграций..."
php artisan migrate --force --no-interaction

# Очищаем и кешируем
echo "⚡ Оптимизация..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Создаем storage link
echo "🔗 Создание storage link..."
php artisan storage:link || true

echo "✨ Приложение готово к работе!"

# Запускаем Apache
exec "$@"
