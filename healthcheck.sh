#!/bin/bash

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🏥 Проверка здоровья Zelen Restaurant API${NC}"
echo "=================================================="
echo ""

# Проверка Docker
echo -n "Проверка Docker... "
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✅${NC}"
else
    echo -e "${RED}❌ Docker не установлен${NC}"
    exit 1
fi

# Проверка Docker Compose
echo -n "Проверка Docker Compose... "
if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}✅${NC}"
else
    echo -e "${RED}❌ Docker Compose не установлен${NC}"
    exit 1
fi

echo ""
echo "Проверка контейнеров:"
echo "----------------------"

# Проверка контейнера app
echo -n "Контейнер app... "
if docker-compose ps | grep "zelen_app" | grep -q "Up"; then
    echo -e "${GREEN}✅ Запущен${NC}"
else
    echo -e "${RED}❌ Не запущен${NC}"
fi

# Проверка контейнера MySQL
echo -n "Контейнер mysql... "
if docker-compose ps | grep "zelen_mysql" | grep -q "Up"; then
    echo -e "${GREEN}✅ Запущен${NC}"

    # Проверка доступности MySQL
    echo -n "Подключение к MySQL... "
    if docker-compose exec -T mysql mysql -u zelen_user -pzelen_password -e "SELECT 1" &> /dev/null; then
        echo -e "${GREEN}✅ Доступен${NC}"
    else
        echo -e "${RED}❌ Недоступен${NC}"
    fi
else
    echo -e "${RED}❌ Не запущен${NC}"
fi

# Проверка контейнера phpMyAdmin
echo -n "Контейнер phpmyadmin... "
if docker-compose ps | grep "zelen_phpmyadmin" | grep -q "Up"; then
    echo -e "${GREEN}✅ Запущен${NC}"
else
    echo -e "${RED}❌ Не запущен${NC}"
fi

echo ""
echo "Проверка эндпоинтов:"
echo "--------------------"

# Проверка API
echo -n "Laravel API (http://localhost:8000)... "
if curl -s -f http://localhost:8000 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Доступен${NC}"
else
    echo -e "${RED}❌ Недоступен${NC}"
fi

# Проверка API health endpoint
echo -n "API Health endpoint... "
if curl -s -f http://localhost:8000/api/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Доступен${NC}"
else
    echo -e "${YELLOW}⚠️  Endpoint не найден (возможно не реализован)${NC}"
fi

# Проверка phpMyAdmin
echo -n "phpMyAdmin (http://localhost:8080)... "
if curl -s -f http://localhost:8080 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Доступен${NC}"
else
    echo -e "${RED}❌ Недоступен${NC}"
fi

echo ""
echo "Проверка файлов конфигурации:"
echo "------------------------------"

# Проверка .env
echo -n "Файл .env... "
if [ -f .env ]; then
    echo -e "${GREEN}✅ Существует${NC}"

    # Проверка APP_KEY
    echo -n "APP_KEY... "
    if grep -q "APP_KEY=base64:" .env; then
        echo -e "${GREEN}✅ Установлен${NC}"
    else
        echo -e "${RED}❌ Не установлен${NC}"
        echo -e "${YELLOW}   Выполните: docker-compose exec app php artisan key:generate${NC}"
    fi

    # Проверка DB_HOST
    echo -n "DB_HOST... "
    if grep -q "DB_HOST=mysql" .env; then
        echo -e "${GREEN}✅ Правильно настроен (mysql)${NC}"
    else
        echo -e "${YELLOW}⚠️  Возможно неправильно настроен${NC}"
        echo -e "${YELLOW}   Должно быть: DB_HOST=mysql${NC}"
    fi
else
    echo -e "${RED}❌ Не существует${NC}"
    echo -e "${YELLOW}   Создайте: cp .env.example .env${NC}"
fi

echo ""
echo "Проверка Laravel:"
echo "-----------------"

# Проверка storage permissions
echo -n "Права storage/... "
if docker-compose exec -T app test -w /var/www/html/storage &> /dev/null; then
    echo -e "${GREEN}✅ Правильные${NC}"
else
    echo -e "${RED}❌ Неправильные${NC}"
    echo -e "${YELLOW}   Исправьте: docker-compose exec app chmod -R 775 storage${NC}"
fi

# Проверка миграций
echo -n "Миграции базы данных... "
if docker-compose exec -T app php artisan migrate:status &> /dev/null; then
    echo -e "${GREEN}✅ Выполнены${NC}"
else
    echo -e "${YELLOW}⚠️  Требуется выполнить${NC}"
    echo -e "${YELLOW}   Выполните: docker-compose exec app php artisan migrate${NC}"
fi

echo ""
echo "=================================================="

# Подсчет ошибок
ERRORS=$(docker-compose ps | grep -c "Exit")

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✨ Все проверки пройдены успешно!${NC}"
    echo ""
    echo "🌐 Доступные сервисы:"
    echo "   - Laravel API: http://localhost:8000"
    echo "   - phpMyAdmin: http://localhost:8080"
    exit 0
else
    echo -e "${RED}⚠️  Обнаружены проблемы!${NC}"
    echo ""
    echo "Проверьте логи:"
    echo "   docker-compose logs -f"
    exit 1
fi
