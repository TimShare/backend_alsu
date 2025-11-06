#!/bin/bash
set -e

echo "🚀 Запуск Docker entrypoint скрипта..."

# Ждем MySQL
echo "⏳ Ожидание MySQL..."
MAX_TRIES=30
TRIES=0
until mysql -h ${DB_HOST:-mysql} -u ${DB_USERNAME:-zelen_user} -p${DB_PASSWORD:-zelen_password} -e "SELECT 1" &> /dev/null
do
    TRIES=$((TRIES+1))
    if [ $TRIES -ge $MAX_TRIES ]; then
        echo "❌ MySQL не стал доступен за $MAX_TRIES попыток. Продолжаем без миграций..."
        break
    fi
    echo "MySQL еще не готов, ждем... попытка $TRIES/$MAX_TRIES"
    sleep 2
done

if [ $TRIES -lt $MAX_TRIES ]; then
    echo "✅ MySQL готов!"
fi

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

# Выполняем миграции только если MySQL доступен
if [ $TRIES -lt $MAX_TRIES ]; then
    echo "🗄️ Выполнение миграций..."
    php artisan migrate --force --no-interaction || echo "⚠️ Миграции не выполнены"
fi

# Очищаем и кешируем
echo "⚡ Оптимизация..."
php artisan config:cache || echo "⚠️ Config cache failed"
php artisan route:cache || echo "⚠️ Route cache failed"
php artisan view:cache || echo "⚠️ View cache failed"

# Создаем storage link
echo "🔗 Создание storage link..."
php artisan storage:link || true

echo "✨ Приложение готово к работе!"

# Запускаем Apache
exec "$@"
