#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для вывода с цветом
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Функция помощи
show_help() {
    echo "🐳 Docker Scripts для Zelen Restaurant API"
    echo ""
    echo "Использование: ./docker-scripts.sh [команда]"
    echo ""
    echo "Команды:"
    echo "  start        - Запустить все контейнеры"
    echo "  stop         - Остановить все контейнеры"
    echo "  restart      - Перезапустить контейнеры"
    echo "  rebuild      - Пересобрать и запустить контейнеры"
    echo "  logs         - Показать логи всех сервисов"
    echo "  logs-app     - Показать логи приложения"
    echo "  logs-mysql   - Показать логи MySQL"
    echo "  shell        - Войти в контейнер приложения"
    echo "  mysql        - Войти в MySQL консоль"
    echo "  migrate      - Выполнить миграции"
    echo "  seed         - Запустить сидеры"
    echo "  fresh        - Пересоздать БД с миграциями и сидерами"
    echo "  composer     - Установить composer зависимости"
    echo "  cache-clear  - Очистить все кеши Laravel"
    echo "  test         - Запустить тесты"
    echo "  status       - Показать статус контейнеров"
    echo "  cleanup      - Удалить все контейнеры и volumes"
    echo "  help         - Показать эту справку"
}

# Запуск контейнеров
start() {
    print_info "Запуск контейнеров..."
    docker-compose up -d
    print_success "Контейнеры запущены!"
    print_info "API: http://localhost:8000"
    print_info "phpMyAdmin: http://localhost:8080"
}

# Остановка контейнеров
stop() {
    print_info "Остановка контейнеров..."
    docker-compose stop
    print_success "Контейнеры остановлены!"
}

# Перезапуск
restart() {
    print_info "Перезапуск контейнеров..."
    docker-compose restart
    print_success "Контейнеры перезапущены!"
}

# Пересборка
rebuild() {
    print_info "Пересборка образов..."
    docker-compose down
    docker-compose build --no-cache
    docker-compose up -d
    print_success "Образы пересобраны и контейнеры запущены!"
}

# Логи
logs() {
    print_info "Показ логов (Ctrl+C для выхода)..."
    docker-compose logs -f
}

logs_app() {
    print_info "Логи приложения (Ctrl+C для выхода)..."
    docker-compose logs -f app
}

logs_mysql() {
    print_info "Логи MySQL (Ctrl+C для выхода)..."
    docker-compose logs -f mysql
}

# Вход в контейнер
shell() {
    print_info "Вход в контейнер приложения..."
    docker-compose exec app bash
}

# MySQL консоль
mysql_console() {
    print_info "Подключение к MySQL..."
    docker-compose exec mysql mysql -u zelen_user -pzelen_password zelen_restaurant
}

# Миграции
migrate() {
    print_info "Выполнение миграций..."
    docker-compose exec app php artisan migrate
    print_success "Миграции выполнены!"
}

# Сидеры
seed() {
    print_info "Запуск сидеров..."
    docker-compose exec app php artisan db:seed
    print_success "Сидеры выполнены!"
}

# Пересоздание БД
fresh() {
    print_warning "Это удалит все данные из БД!"
    read -p "Продолжить? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        print_info "Пересоздание базы данных..."
        docker-compose exec app php artisan migrate:fresh --seed
        print_success "База данных пересоздана!"
    else
        print_info "Операция отменена"
    fi
}

# Composer
composer_install() {
    print_info "Установка composer зависимостей..."
    docker-compose exec app composer install
    print_success "Зависимости установлены!"
}

# Очистка кеша
cache_clear() {
    print_info "Очистка кешей..."
    docker-compose exec app php artisan config:clear
    docker-compose exec app php artisan cache:clear
    docker-compose exec app php artisan route:clear
    docker-compose exec app php artisan view:clear
    print_success "Все кеши очищены!"
}

# Тесты
run_tests() {
    print_info "Запуск тестов..."
    docker-compose exec app php artisan test
}

# Статус
status() {
    print_info "Статус контейнеров:"
    docker-compose ps
}

# Полная очистка
cleanup() {
    print_warning "Это удалит ВСЕ контейнеры, образы и volumes!"
    read -p "Продолжить? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        print_info "Удаление контейнеров и volumes..."
        docker-compose down -v
        print_success "Очистка завершена!"
    else
        print_info "Операция отменена"
    fi
}

# Главная логика
case "${1}" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    rebuild)
        rebuild
        ;;
    logs)
        logs
        ;;
    logs-app)
        logs_app
        ;;
    logs-mysql)
        logs_mysql
        ;;
    shell)
        shell
        ;;
    mysql)
        mysql_console
        ;;
    migrate)
        migrate
        ;;
    seed)
        seed
        ;;
    fresh)
        fresh
        ;;
    composer)
        composer_install
        ;;
    cache-clear)
        cache_clear
        ;;
    test)
        run_tests
        ;;
    status)
        status
        ;;
    cleanup)
        cleanup
        ;;
    help|*)
        show_help
        ;;
esac
