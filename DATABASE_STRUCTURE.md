# Структура базы данных

## Схема таблиц

### 1. users
Хранит информацию о пользователях

| Поле | Тип | Описание |
|------|-----|----------|
| id | bigint | Primary key |
| name | string(255) | Имя пользователя |
| email | string(255) | Email (unique) |
| password | string(255) | Хешированный пароль |
| phone | string(20) | Телефон (nullable) |
| role | enum | user, dietolog, admin |
| created_at | timestamp | Дата создания |
| updated_at | timestamp | Дата обновления |

### 2. menu_items
Блюда меню

| Поле | Тип | Описание |
|------|-----|----------|
| id | bigint | Primary key |
| name | string(255) | Название блюда |
| description | text | Описание |
| price | decimal(8,2) | Цена |
| image | string(255) | URL изображения |
| category | enum | завтрак, основное, напитки, десерты |
| is_available | boolean | Доступность (default true) |
| created_at | timestamp | Дата создания |
| updated_at | timestamp | Дата обновления |

### 3. orders
Заказы пользователей

| Поле | Тип | Описание |
|------|-----|----------|
| id | bigint | Primary key |
| user_id | bigint | Foreign key -> users.id |
| total_amount | decimal(10,2) | Общая сумма |
| status | enum | pending, confirmed, preparing, ready, delivered, cancelled |
| delivery_address | string(500) | Адрес доставки |
| delivery_time | string(50) | Время доставки |
| phone | string(20) | Телефон для связи |
| comment | text | Комментарий (nullable) |
| created_at | timestamp | Дата создания |
| updated_at | timestamp | Дата обновления |

### 4. order_items
Позиции в заказе

| Поле | Тип | Описание |
|------|-----|----------|
| id | bigint | Primary key |
| order_id | bigint | Foreign key -> orders.id |
| menu_item_id | bigint | Foreign key -> menu_items.id |
| quantity | integer | Количество |
| price | decimal(8,2) | Цена на момент заказа |
| created_at | timestamp | Дата создания |
| updated_at | timestamp | Дата обновления |

### 5. consultations
Консультации с диетологом

| Поле | Тип | Описание |
|------|-----|----------|
| id | bigint | Primary key |
| user_id | bigint | Foreign key -> users.id |
| name | string(255) | Имя клиента |
| email | string(255) | Email клиента |
| phone | string(20) | Телефон |
| date | date | Дата консультации |
| time | time | Время консультации |
| message | text | Сообщение от клиента |
| status | enum | pending, scheduled, completed, cancelled |
| dietolog_id | bigint | Foreign key -> users.id (nullable) |
| notes | text | Заметки диетолога (nullable) |
| created_at | timestamp | Дата создания |
| updated_at | timestamp | Дата обновления |

## Связи между таблицами

```
users (1) ----< (N) orders
users (1) ----< (N) consultations
orders (1) ----< (N) order_items
menu_items (1) ----< (N) order_items
users (dietolog) (1) ----< (N) consultations (assigned)
```

## Индексы

- `users.email` - unique
- `orders.user_id` - index
- `orders.status` - index
- `order_items.order_id` - index
- `order_items.menu_item_id` - index
- `consultations.user_id` - index
- `consultations.status` - index
- `consultations.dietolog_id` - index
- `menu_items.category` - index
- `menu_items.is_available` - index
