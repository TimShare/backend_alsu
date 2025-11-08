# Инструкции по запуску в GitHub Codespaces

## Что было исправлено

### Проблема
При запуске devcontainer в Codespaces возникала ошибка "Container creation failed", хотя Docker Compose успешно запускал контейнеры.

### Причины
1. **Отсутствие Composer** - образ PHP не содержал Composer
2. **Отсутствие MySQL клиента** - команда `mysql` была недоступна
3. **Отсутствие PHP расширений** - не все необходимые для Laravel расширения были установлены

### Решение
1. Добавлены DevContainer Features для PHP и Node.js с автоматической установкой Composer
2. Обновлен скрипт `setup-codespaces.sh`:
   - Установка системных зависимостей (MySQL клиент, библиотеки для изображений)
   - Установка PHP расширений (pdo, pdo_mysql, mysqli, gd)
   - Проверка и установка Composer при необходимости
   - Улучшенная проверка готовности MySQL с таймаутом
   - Обработка ошибок при выполнении миграций
3. Обновлена конфигурация `.env.codespaces` для поддержки Codespaces URL

## Запуск в Codespaces

### 1. Создание Codespace
```bash
# Откройте репозиторий на GitHub
# Нажмите Code → Codespaces → Create codespace on main
```

### 2. Автоматическая настройка
После создания Codespace автоматически:
- Запустятся Docker контейнеры (MySQL, phpMyAdmin, App)
- Установятся системные зависимости и PHP расширения
- Установятся Composer зависимости
- Создастся файл `.env` из `.env.codespaces`
- Сгенерируется `APP_KEY`
- Выполнятся миграции базы данных
- Запустится Laravel сервер на порту 8000

### 3. Проверка статуса
После завершения настройки откройте терминал и проверьте:

```bash
# Проверить работу контейнеров
docker ps

# Проверить логи Laravel
tail -f /tmp/laravel.log

# Проверить подключение к MySQL
mysql -h mysql -u zelen_user -pzelen_password zelen_restaurant -e "SHOW TABLES;"
```

### 4. Доступ к сервисам

Перейдите на вкладку **PORTS** в VS Code и найдите:
- **8000** - Laravel API (кликните на иконку глобуса для открытия)
- **8080** - phpMyAdmin (для управления базой данных)
- **3306** - MySQL (для прямого подключения)

## Ручной запуск сервера (если нужно)

Если сервер не запустился автоматически:

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

## Выполнение миграций вручную

Если миграции не выполнились автоматически:

```bash
# Проверить подключение к БД
php artisan migrate:status

# Выполнить миграции
php artisan migrate --force

# Заполнить БД тестовыми данными (если есть seeders)
php artisan db:seed
```

## Полезные команды

```bash
# Очистка кеша
php artisan cache:clear
php artisan config:clear
php artisan route:clear

# Просмотр маршрутов
php artisan route:list

# Проверка окружения
php artisan env

# Tinker (Laravel REPL)
php artisan tinker
```

## Решение проблем

### MySQL не подключается
```bash
# Проверить статус MySQL
docker ps | grep mysql

# Перезапустить MySQL
docker restart zelen_mysql

# Проверить логи MySQL
docker logs zelen_mysql
```

### Ошибки с правами доступа
```bash
# Установить правильные права на storage и cache
chmod -R 775 storage bootstrap/cache
```

### Composer ошибки
```bash
# Очистка кеша Composer
composer clear-cache

# Переустановка зависимостей
rm -rf vendor composer.lock
composer install
```

### Полная переустановка
```bash
# Остановить все контейнеры
docker compose -f docker-compose.codespaces.yml down -v

# Запустить заново
docker compose -f docker-compose.codespaces.yml up -d

# Выполнить setup скрипт вручную
bash .devcontainer/setup-codespaces.sh
```

## Структура файлов

```
.devcontainer/
├── devcontainer.json          # Конфигурация DevContainer
├── setup-codespaces.sh        # Скрипт автоматической настройки
└── CODESPACES.md             # Эта инструкция

docker-compose.codespaces.yml  # Docker Compose для Codespaces
.env.codespaces                # Шаблон переменных окружения
```

## Важные замечания

1. **Не коммитить .env** - файл `.env` создается автоматически из `.env.codespaces`
2. **CORS настроен** - API доступен с любых Codespaces доменов (*.app.github.dev)
3. **Порты проброшены** - все порты автоматически forwarding'ятся VS Code
4. **MySQL хранится в volume** - данные сохраняются между перезапусками
5. **Автозапуск сервера** - Laravel сервер стартует через `postStartCommand`

## Техническая информация

- **PHP версия**: 8.2
- **Laravel версия**: 10.x
- **MySQL версия**: 8.0
- **Base образ**: mcr.microsoft.com/devcontainers/php:1-8.2
- **Установленные расширения**: pdo, pdo_mysql, mysqli, gd

## Обратная связь

Если возникли проблемы, проверьте логи:
- DevContainer: в OUTPUT панели VS Code выберите "Dev Containers"
- Laravel: `/tmp/laravel.log`
- MySQL: `docker logs zelen_mysql`
- Docker Compose: `docker compose -f docker-compose.codespaces.yml logs`
