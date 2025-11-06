# Установка Backend для Ресторана "Зелень"

## Требования

- PHP >= 8.1
- Composer
- MySQL >= 5.7 или PostgreSQL >= 10
- Laravel 10.x

## Шаг 1: Установка PHP и Composer (macOS)

### Установка PHP через Homebrew

```bash
# Установите Homebrew, если еще не установлен
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Установите PHP
brew install php@8.2

# Проверьте установку
php --version
```

### Установка Composer

```bash
# Скачайте и установите Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Проверьте установку
composer --version
```

## Шаг 2: Создание Laravel проекта

```bash
# Перейдите в директорию
cd /Users/timshare/Documents/diplom/backend_alsu

# Создайте новый Laravel проект
composer create-project laravel/laravel .

# Или установите Laravel Installer глобально
composer global require laravel/installer
laravel new backend_alsu
```

## Шаг 3: Настройка базы данных

### Вариант 1: MySQL

```bash
# Установите MySQL
brew install mysql
brew services start mysql

# Создайте базу данных
mysql -u root -p
CREATE DATABASE zelen_restaurant;
CREATE USER 'zelen_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON zelen_restaurant.* TO 'zelen_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Вариант 2: PostgreSQL

```bash
# Установите PostgreSQL
brew install postgresql@14
brew services start postgresql@14

# Создайте базу данных
psql postgres
CREATE DATABASE zelen_restaurant;
CREATE USER zelen_user WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE zelen_restaurant TO zelen_user;
\q
```

### Настройте .env файл

```env
APP_NAME="Zelen Restaurant API"
APP_ENV=local
APP_KEY=base64:... # будет сгенерирован автоматически
APP_DEBUG=true
APP_URL=http://localhost:3001

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=zelen_restaurant
DB_USERNAME=zelen_user
DB_PASSWORD=password

# Для PostgreSQL используйте:
# DB_CONNECTION=pgsql
# DB_PORT=5432
```

## Шаг 4: Установка зависимостей

```bash
# Установите Laravel Sanctum для API авторизации
composer require laravel/sanctum

# Опубликуйте конфигурацию Sanctum
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```

## Шаг 5: Запуск миграций

После создания всех миграций (см. следующие шаги):

```bash
# Сгенерируйте ключ приложения
php artisan key:generate

# Запустите миграции
php artisan migrate

# Запустите seeders для тестовых данных
php artisan db:seed
```

## Шаг 6: Запуск сервера

```bash
# Запустите dev сервер на порту 3001
php artisan serve --port=3001

# Или укажите хост
php artisan serve --host=127.0.0.1 --port=3001
```

API будет доступен по адресу: `http://localhost:3001/api`

## Шаг 7: Тестирование API

```bash
# Тестовый запрос к API
curl http://localhost:3001/api/menu

# Тест авторизации
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@zelen.ru","password":"admin123"}'
```

## Возможные проблемы

### Ошибка: "Extension required"

```bash
# Установите необходимые расширения PHP
brew install php@8.2-mbstring php@8.2-xml php@8.2-curl
```

### Ошибка: "Permission denied"

```bash
# Дайте права на запись
chmod -R 775 storage bootstrap/cache
```

### Ошибка: "Port already in use"

```bash
# Используйте другой порт
php artisan serve --port=8000
```

## Следующие шаги

После установки:
1. Создайте миграции (см. DATABASE_STRUCTURE.md)
2. Создайте модели и контроллеры (см. API_DOCUMENTATION.md)
3. Настройте CORS для frontend
4. Протестируйте все endpoints
