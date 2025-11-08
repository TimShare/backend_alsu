#!/bin/bash
set -e

echo "🚀 Настройка Laravel для Codespaces с MySQL..."

# 0. Установка необходимых зависимостей
echo "📦 Установка системных зависимостей..."
apt-get update -qq
apt-get install -y -qq \
  default-mysql-client \
  libpng-dev \
  libjpeg-dev \
  libfreetype6-dev \
  zip \
  unzip \
  > /dev/null 2>&1

# Установка PHP расширений
echo "🔧 Установка PHP расширений..."
docker-php-ext-configure gd --with-freetype --with-jpeg > /dev/null 2>&1
docker-php-ext-install -j$(nproc) gd pdo pdo_mysql mysqli > /dev/null 2>&1

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

# 3. Проверка Composer
echo "🔍 Проверка Composer..."
if ! command -v composer &> /dev/null; then
    echo "⚠️  Composer не найден, устанавливаю..."
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
fi
composer --version

# 4. Установка composer зависимостей
echo "📦 Установка Composer зависимостей..."
composer install --no-interaction --prefer-dist --optimize-autoloader

# 5. Генерация APP_KEY
echo "🔑 Генерация APP_KEY..."
php artisan key:generate --no-interaction

# 6. Ожидание готовности MySQL
echo "⏳ Ожидание MySQL..."
MYSQL_READY=0
for i in {1..30}; do
  if mysqladmin ping -h mysql -u root -proot_password --silent &> /dev/null; then
    echo "✅ MySQL сервер доступен!"
    # Проверяем доступность базы данных
    if mysql -h mysql -u zelen_user -pzelen_password -e "USE zelen_restaurant; SELECT 1" &> /dev/null; then
      echo "✅ База данных zelen_restaurant готова!"
      MYSQL_READY=1
      break
    fi
  fi
  echo "⏳ Ждем MySQL... попытка $i/30"
  sleep 3
done

if [ $MYSQL_READY -eq 0 ]; then
  echo "❌ MySQL не готов, но продолжаем..."
  echo "💡 Возможно потребуется ручной запуск миграций"
fi

# 7. Выполнение миграций (с обработкой ошибок)
echo "🗄️ Выполнение миграций..."
if [ $MYSQL_READY -eq 1 ]; then
  if php artisan migrate --force --no-interaction; then
    echo "✅ Миграции выполнены успешно!"
  else
    echo "⚠️  Ошибка при выполнении миграций"
  fi
else
  echo "⏭️  Пропускаем миграции (MySQL не готов)"
fi

# 8. Очистка кеша
echo "🧹 Очистка кеша..."
php artisan config:clear
php artisan cache:clear
php artisan route:clear

echo ""
echo "✅ Настройка завершена!"
echo ""
echo "🚀 Сервер запустится автоматически через postStartCommand"
echo "🎉 Готово! Откройте порт 8000 из вкладки PORTS"
