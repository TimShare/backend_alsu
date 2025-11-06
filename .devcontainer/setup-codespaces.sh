#!/bin/bash
set -e

echo "🚀 Настройка Laravel для Codespaces с MySQL..."

# 1. Создание необходимых директорий
echo "📁 Создание директорий..."
mkdir -p storage/framework/{sessions,views,cache,testing}
mkdir -p storage/logs
mkdir -p storage/app/public
mkdir -p bootstrap/cache
chmod -R 775 storage bootstrap/cache

# 2. Создание .env файла
echo "📝 Создание .env файла..."
if [ ! -f .env ]; then
    cp .env.codespaces .env
fi

# 3. Установка composer зависимостей
echo "📦 Установка Composer зависимостей..."
composer install --no-interaction --prefer-dist

# 4. Генерация APP_KEY
echo "🔑 Генерация APP_KEY..."
php artisan key:generate --no-interaction

# 5. Ожидание готовности MySQL
echo "⏳ Ожидание MySQL..."
for i in {1..60}; do
  if mysql -h mysql -u zelen_user -pzelen_password zelen_restaurant -e "SELECT 1" &> /dev/null; then
    echo "✅ MySQL готов!"
    break
  fi
  if [ $i -eq 60 ]; then
    echo "❌ MySQL не запустился за 2 минуты"
    exit 1
  fi
  echo "Ждем MySQL... попытка $i/60"
  sleep 2
done

# 6. Выполнение миграций
echo "🗄️ Выполнение миграций..."
php artisan migrate --force --no-interaction

# 7. Очистка кеша
echo "🧹 Очистка кеша..."
php artisan config:clear
php artisan cache:clear

echo ""
echo "✅ Настройка завершена!"
echo ""
echo "🚀 Сервер запустится автоматически через postStartCommand"
echo "🎉 Готово! Откройте порт 8000 из вкладки PORTS"
