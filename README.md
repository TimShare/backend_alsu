# Backend API для Ресторана "Зелень"

Laravel REST API для веб-сайта ресторана здорового питания с системой авторизации, управлением меню, заказами и консультациями.

## Особенности

- Аутентификация с использованием Laravel Sanctum
- Система ролей (User, Dietolog, Admin)
- CRUD операции для меню
- Управление заказами
- Система бронирования консультаций
- CORS настроен для frontend
- Seeder с тестовыми данными

## Требования

- PHP >= 8.1
- Composer
- MySQL >= 5.7 или PostgreSQL >= 10
- Laravel 10.x

## Быстрый старт

### 1. Установка зависимостей

После установки PHP и Composer (см. INSTALLATION.md):

```bash
# Перейдите в директорию проекта
cd /Users/timshare/Documents/diplom/backend_alsu

# Создайте Laravel проект
composer create-project laravel/laravel .

# Установите Sanctum
composer require laravel/sanctum
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```

### 2. Настройка окружения

```bash
# Скопируйте .env.example в .env
cp .env.example .env

# Сгенерируйте ключ приложения
php artisan key:generate

# Настройте параметры базы данных в .env файле
```

### 3. База данных

```bash
# Создайте базу данных
mysql -u root -p
CREATE DATABASE zelen_restaurant;
CREATE USER 'zelen_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON zelen_restaurant.* TO 'zelen_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# Запустите миграции
php artisan migrate

# Запустите seeders
php artisan db:seed
```

### 4. Запуск сервера

```bash
php artisan serve --port=3001
```

API будет доступен по адресу: http://localhost:3001/api

## Структура проекта

```
backend_alsu/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       ├── AuthController.php
│   │   │       ├── MenuController.php
│   │   │       ├── OrderController.php
│   │   │       └── ConsultationController.php
│   │   └── Middleware/
│   │       ├── AdminMiddleware.php
│   │       └── DietologMiddleware.php
│   └── Models/
│       ├── User.php
│       ├── MenuItem.php
│       ├── Order.php
│       ├── OrderItem.php
│       └── Consultation.php
├── database/
│   ├── migrations/
│   │   ├── 2024_01_01_000000_create_users_table.php
│   │   ├── 2024_01_01_000001_create_menu_items_table.php
│   │   ├── 2024_01_01_000002_create_orders_table.php
│   │   ├── 2024_01_01_000003_create_order_items_table.php
│   │   └── 2024_01_01_000004_create_consultations_table.php
│   └── seeders/
│       └── DatabaseSeeder.php
├── routes/
│   └── api.php
├── config/
│   └── cors.php
└── .env.example
```

## API Endpoints

### Авторизация

- `POST /api/auth/register` - Регистрация
- `POST /api/auth/login` - Вход
- `POST /api/auth/logout` - Выход (требует авторизации)
- `GET /api/auth/me` - Текущий пользователь (требует авторизации)

### Меню

- `GET /api/menu` - Получить все блюда
- `GET /api/menu/{id}` - Получить блюдо
- `POST /api/menu` - Создать блюдо (только Admin)
- `PUT /api/menu/{id}` - Обновить блюдо (только Admin)
- `DELETE /api/menu/{id}` - Удалить блюдо (только Admin)

### Заказы

- `GET /api/orders` - Получить заказы (требует авторизации)
- `GET /api/orders/{id}` - Получить заказ (требует авторизации)
- `POST /api/orders` - Создать заказ (требует авторизации)

### Консультации

- `POST /api/consultations` - Забронировать консультацию
- `GET /api/consultations` - Получить все консультации (только Dietolog/Admin)
- `PUT /api/consultations/{id}` - Обновить консультацию (только Dietolog/Admin)

## Тестовые аккаунты

После запуска seeders будут доступны следующие аккаунты:

**Администратор:**
- Email: `admin@zelen.ru`
- Пароль: `admin123`

**Диетолог:**
- Email: `dietolog@zelen.ru`
- Пароль: `dietolog123`

**Пользователь:**
- Email: `test@example.com`
- Пароль: `password`

## Примеры запросов

### Вход в систему

```bash
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@zelen.ru","password":"admin123"}'
```

### Получение меню

```bash
curl http://localhost:3001/api/menu
```

### Создание заказа

```bash
curl -X POST http://localhost:3001/api/orders \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "items": [
      {"menu_item_id": 1, "quantity": 2},
      {"menu_item_id": 3, "quantity": 1}
    ],
    "delivery_address": "Казань, ул. Баумана, 10",
    "delivery_time": "14:00 - 15:00",
    "phone": "+79371234567",
    "comment": "Позвоните за 10 минут"
  }'
```

## Интеграция с Frontend

В вашем React frontend измените `.env` файл:

```env
VITE_USE_MOCK_API=false
VITE_API_URL=http://localhost:3001/api
```

Теперь frontend будет использовать реальный Laravel API вместо mock данных.

## Документация

- **INSTALLATION.md** - Подробная инструкция по установке
- **DATABASE_STRUCTURE.md** - Структура базы данных
- **COMPLETE_API_GUIDE.md** - Полное руководство по API с примерами

## Разработка

### Полезные команды

```bash
# Очистка кэша
php artisan config:clear
php artisan cache:clear
php artisan route:clear

# Просмотр маршрутов
php artisan route:list

# Создание новой миграции
php artisan make:migration create_table_name

# Создание нового контроллера
php artisan make:controller ControllerName

# Создание новой модели
php artisan make:model ModelName
```

### Тестирование API

Рекомендуется использовать:
- Postman
- Insomnia
- Thunder Client (VS Code extension)
- curl

## Безопасность

- Все пароли хешируются с использованием bcrypt
- API защищен с помощью Laravel Sanctum
- CORS настроен для разрешенных доменов
- Middleware для проверки ролей пользователей
- Валидация всех входящих данных

## Производительность

- Используются Eloquent relationships для оптимизации запросов
- Транзакции для операций с заказами
- Индексы на часто используемых полях

## Возможные улучшения

- [ ] Добавить пагинацию для списков
- [ ] Реализовать кэширование меню
- [ ] Добавить систему уведомлений (email/SMS)
- [ ] Интегрировать платежную систему
- [ ] Добавить загрузку изображений
- [ ] Реализовать систему отзывов
- [ ] Добавить логирование действий пользователей
- [ ] Создать админ-панель

## Лицензия

MIT License

## Контакты

При возникновении вопросов обращайтесь:
- Email: zelen@gmail.com
- Телефон: +7 (937) 525-21-72

---

Создано с ❤️ для ресторана "Зелень"
# backend_alsu
# backend_alsu
# backend_alsu
