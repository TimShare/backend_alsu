#!/bin/bash

echo "🚀 Запуск инициализации Laravel приложения..."

# Ждем, пока MySQL будет готов
echo "⏳ Ожидание готовности MySQL..."
until mysql -h mysql -u zelen_user -pzelen_password -e "SELECT 1" &> /dev/null
do
    echo "MySQL еще не готов, ждем..."
    sleep 2
done

echo "✅ MySQL готов!"

# Устанавливаем права доступа
echo "📁 Настройка прав доступа..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Копируем .env файл, если его нет
if [ ! -f /var/www/html/.env ]; then
    echo "📄 Создание .env файла..."
    cp /var/www/html/.env.example /var/www/html/.env

    # Обновляем настройки базы данных
    sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/g' /var/www/html/.env
    sed -i 's/DB_PASSWORD=password/DB_PASSWORD=zelen_password/g' /var/www/html/.env
fi

# Генерируем ключ приложения
if ! grep -q "base64" /var/www/html/.env; then
    echo "🔑 Генерация APP_KEY..."
    php artisan key:generate --no-interaction
fi

# Устанавливаем зависимости
echo "📦 Установка Composer зависимостей..."
composer install --no-interaction --prefer-dist --optimize-autoloader

# Выполняем миграции
echo "🗄️ Выполнение миграций базы данных..."
php artisan migrate --force --no-interaction

# Очищаем кеш
echo "🧹 Очистка кеша..."
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

# Кешируем конфигурацию
echo "⚡ Кеширование конфигурации..."
php artisan config:cache
php artisan route:cache

# Создаем символическую ссылку для storage
echo "🔗 Создание символической ссылки для storage..."
php artisan storage:link

echo "✨ Инициализация завершена!"
echo "🌐 Приложение доступно на порту 8000"
echo "🗄️ phpMyAdmin доступен на порту 8080"
echo ""
echo "📚 Учетные данные MySQL:"
echo "   Host: mysql"
echo "   Database: zelen_restaurant"
echo "   Username: zelen_user"
echo "   Password: zelen_password"
echo "   Root Password: root_password"
