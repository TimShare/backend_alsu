.PHONY: help start stop restart rebuild logs shell mysql migrate seed fresh composer cache-clear test status cleanup

# Цвета для вывода
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m

help: ## Показать эту справку
	@echo "$(BLUE)🐳 Makefile команды для Zelen Restaurant API$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'

start: ## Запустить все контейнеры
	@echo "$(BLUE)Запуск контейнеров...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)✅ Контейнеры запущены!$(NC)"
	@echo "API: http://localhost:8000"
	@echo "phpMyAdmin: http://localhost:8080"

stop: ## Остановить все контейнеры
	@echo "$(BLUE)Остановка контейнеров...$(NC)"
	docker-compose stop
	@echo "$(GREEN)✅ Контейнеры остановлены!$(NC)"

restart: ## Перезапустить контейнеры
	@echo "$(BLUE)Перезапуск контейнеров...$(NC)"
	docker-compose restart
	@echo "$(GREEN)✅ Контейнеры перезапущены!$(NC)"

rebuild: ## Пересобрать и запустить контейнеры
	@echo "$(BLUE)Пересборка образов...$(NC)"
	docker-compose down
	docker-compose build --no-cache
	docker-compose up -d
	@echo "$(GREEN)✅ Образы пересобраны!$(NC)"

logs: ## Показать логи всех сервисов
	docker-compose logs -f

logs-app: ## Показать логи приложения
	docker-compose logs -f app

logs-mysql: ## Показать логи MySQL
	docker-compose logs -f mysql

shell: ## Войти в контейнер приложения
	@echo "$(BLUE)Вход в контейнер приложения...$(NC)"
	docker-compose exec app bash

mysql: ## Войти в MySQL консоль
	@echo "$(BLUE)Подключение к MySQL...$(NC)"
	docker-compose exec mysql mysql -u zelen_user -pzelen_password zelen_restaurant

migrate: ## Выполнить миграции
	@echo "$(BLUE)Выполнение миграций...$(NC)"
	docker-compose exec app php artisan migrate
	@echo "$(GREEN)✅ Миграции выполнены!$(NC)"

seed: ## Запустить сидеры
	@echo "$(BLUE)Запуск сидеров...$(NC)"
	docker-compose exec app php artisan db:seed
	@echo "$(GREEN)✅ Сидеры выполнены!$(NC)"

fresh: ## Пересоздать БД с миграциями и сидерами (УДАЛИТ ВСЕ ДАННЫЕ!)
	@echo "$(YELLOW)⚠️  Это удалит все данные из БД!$(NC)"
	@read -p "Продолжить? [y/N] " -n 1 -r; \
	echo; \
	if [ "$$REPLY" = "y" ] || [ "$$REPLY" = "Y" ]; then \
		echo "$(BLUE)Пересоздание базы данных...$(NC)"; \
		docker-compose exec app php artisan migrate:fresh --seed; \
		echo "$(GREEN)✅ База данных пересоздана!$(NC)"; \
	else \
		echo "Операция отменена"; \
	fi

composer: ## Установить composer зависимости
	@echo "$(BLUE)Установка composer зависимостей...$(NC)"
	docker-compose exec app composer install
	@echo "$(GREEN)✅ Зависимости установлены!$(NC)"

composer-update: ## Обновить composer зависимости
	@echo "$(BLUE)Обновление composer зависимостей...$(NC)"
	docker-compose exec app composer update
	@echo "$(GREEN)✅ Зависимости обновлены!$(NC)"

cache-clear: ## Очистить все кеши Laravel
	@echo "$(BLUE)Очистка кешей...$(NC)"
	docker-compose exec app php artisan config:clear
	docker-compose exec app php artisan cache:clear
	docker-compose exec app php artisan route:clear
	docker-compose exec app php artisan view:clear
	@echo "$(GREEN)✅ Все кеши очищены!$(NC)"

cache-warm: ## Прогреть кеши Laravel
	@echo "$(BLUE)Прогрев кешей...$(NC)"
	docker-compose exec app php artisan config:cache
	docker-compose exec app php artisan route:cache
	docker-compose exec app php artisan view:cache
	@echo "$(GREEN)✅ Кеши прогреты!$(NC)"

test: ## Запустить тесты
	@echo "$(BLUE)Запуск тестов...$(NC)"
	docker-compose exec app php artisan test

status: ## Показать статус контейнеров
	@echo "$(BLUE)Статус контейнеров:$(NC)"
	docker-compose ps

cleanup: ## Удалить все контейнеры и volumes (УДАЛИТ ВСЕ ДАННЫЕ!)
	@echo "$(YELLOW)⚠️  Это удалит ВСЕ контейнеры, образы и volumes!$(NC)"
	@read -p "Продолжить? [y/N] " -n 1 -r; \
	echo; \
	if [ "$$REPLY" = "y" ] || [ "$$REPLY" = "Y" ]; then \
		echo "$(BLUE)Удаление контейнеров и volumes...$(NC)"; \
		docker-compose down -v; \
		echo "$(GREEN)✅ Очистка завершена!$(NC)"; \
	else \
		echo "Операция отменена"; \
	fi

key-generate: ## Сгенерировать APP_KEY
	@echo "$(BLUE)Генерация APP_KEY...$(NC)"
	docker-compose exec app php artisan key:generate
	@echo "$(GREEN)✅ APP_KEY сгенерирован!$(NC)"

routes: ## Показать список маршрутов
	docker-compose exec app php artisan route:list

db-backup: ## Создать backup базы данных
	@echo "$(BLUE)Создание backup базы данных...$(NC)"
	docker-compose exec mysql mysqldump -u zelen_user -pzelen_password zelen_restaurant > backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)✅ Backup создан!$(NC)"

db-restore: ## Восстановить базу данных из backup (укажите файл: make db-restore FILE=backup.sql)
	@if [ -z "$(FILE)" ]; then \
		echo "$(YELLOW)⚠️  Укажите файл: make db-restore FILE=backup.sql$(NC)"; \
	else \
		echo "$(BLUE)Восстановление базы данных из $(FILE)...$(NC)"; \
		docker-compose exec -T mysql mysql -u zelen_user -pzelen_password zelen_restaurant < $(FILE); \
		echo "$(GREEN)✅ База данных восстановлена!$(NC)"; \
	fi

install: start migrate key-generate ## Полная установка (start + migrate + key-generate)
	@echo "$(GREEN)✅ Установка завершена!$(NC)"
	@echo "API доступен на: http://localhost:8000"
	@echo "phpMyAdmin доступен на: http://localhost:8080"
