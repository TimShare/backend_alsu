# ⚡ Quick Start Guide

## 🐳 Локальный запуск (Docker)

```bash
# 1. Клонируйте репозиторий
git clone <ваш-репозиторий>
cd backend_alsu

# 2. Запустите Docker Compose
docker-compose up -d

# 3. Готово! Откройте в браузере:
# - API: http://localhost:8000
# - phpMyAdmin: http://localhost:8080
```

## ☁️ GitHub Codespaces (в один клик)

1. Откройте репозиторий на GitHub
2. Нажмите кнопку `Code` → `Codespaces` → `Create codespace on main`
3. Дождитесь автоматической настройки (2-3 минуты)
4. Готово! Порты будут автоматически проброшены

## 🔑 Учетные данные

### MySQL
- **Host**: `mysql` (в Docker) или `localhost` (локально)
- **Database**: `zelen_restaurant`
- **Username**: `zelen_user`
- **Password**: `zelen_password`

### phpMyAdmin
- **URL**: http://localhost:8080
- **Username**: `root`
- **Password**: `root_password`

## 📝 Полезные команды

```bash
# Просмотр логов
docker-compose logs -f

# Выполнить миграции
docker-compose exec app php artisan migrate

# Войти в контейнер
docker-compose exec app bash

# Остановить контейнеры
docker-compose down
```

## 📚 Подробная документация

Смотрите [DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md) для полной инструкции.
