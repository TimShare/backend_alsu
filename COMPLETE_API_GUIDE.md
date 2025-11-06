# Полное руководство по API для Ресторана "Зелень"

## Оглавление
1. [Авторизация](#авторизация)
2. [Меню](#меню)
3. [Заказы](#заказы)
4. [Консультации](#консультации)
5. [Примеры контроллеров](#примеры-контроллеров)
6. [Routes (Маршруты)](#routes)
7. [Middleware](#middleware)
8. [Seeders](#seeders)

---

## Авторизация

### POST /api/auth/register
Регистрация нового пользователя

**Request:**
```json
{
  "name": "Иван Иванов",
  "email": "ivan@example.com",
  "password": "password123",
  "phone": "+79371234567"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Регистрация успешна",
  "data": {
    "user": {
      "id": 1,
      "name": "Иван Иванов",
      "email": "ivan@example.com",
      "phone": "+79371234567",
      "role": "user"
    },
    "token": "1|abcdef..."
  }
}
```

### POST /api/auth/login
Вход пользователя

**Request:**
```json
{
  "email": "admin@zelen.ru",
  "password": "admin123"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Вход выполнен успешно",
  "data": {
    "user": {
      "id": 1,
      "name": "Администратор",
      "email": "admin@zelen.ru",
      "phone": "+79371234567",
      "role": "admin"
    },
    "token": "2|ghijkl..."
  }
}
```

### POST /api/auth/logout
Выход пользователя (требует авторизации)

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Выход выполнен успешно"
}
```

### GET /api/auth/me
Получение информации о текущем пользователе

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "name": "Администратор",
      "email": "admin@zelen.ru",
      "phone": "+79371234567",
      "role": "admin"
    }
  }
}
```

---

## Меню

### GET /api/menu
Получение всех блюд меню

**Query Parameters:**
- `category` (optional) - фильтр по категории (завтрак, основное, напитки, десерты)
- `available` (optional) - только доступные блюда (true/false)

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Овсяная каша с ягодами",
      "description": "Полезный завтрак с свежими ягодами",
      "price": "250.00",
      "image": "https://example.com/image.jpg",
      "category": "завтрак",
      "is_available": true,
      "created_at": "2024-01-01T00:00:00.000000Z",
      "updated_at": "2024-01-01T00:00:00.000000Z"
    }
  ]
}
```

### GET /api/menu/{id}
Получение конкретного блюда

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Овсяная каша с ягодами",
    "description": "Полезный завтрак с свежими ягодами",
    "price": "250.00",
    "image": "https://example.com/image.jpg",
    "category": "завтрак",
    "is_available": true
  }
}
```

### POST /api/menu (Admin only)
Создание нового блюда

**Headers:**
```
Authorization: Bearer {admin_token}
```

**Request:**
```json
{
  "name": "Новое блюдо",
  "description": "Описание блюда",
  "price": 350.50,
  "image": "https://example.com/image.jpg",
  "category": "основное",
  "is_available": true
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Блюдо успешно создано",
  "data": {
    "id": 10,
    "name": "Новое блюдо",
    ...
  }
}
```

### PUT /api/menu/{id} (Admin only)
Обновление блюда

**Headers:**
```
Authorization: Bearer {admin_token}
```

**Request:**
```json
{
  "name": "Обновленное название",
  "price": 400.00
}
```

### DELETE /api/menu/{id} (Admin only)
Удаление блюда

**Headers:**
```
Authorization: Bearer {admin_token}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Блюдо успешно удалено"
}
```

---

## Заказы

### GET /api/orders
Получение заказов пользователя

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "user_id": 1,
      "total_amount": "1250.00",
      "status": "pending",
      "delivery_address": "Казань, ул. Баумана, 10",
      "delivery_time": "14:00 - 15:00",
      "phone": "+79371234567",
      "comment": "Позвоните за 10 минут",
      "created_at": "2024-01-01T12:00:00.000000Z",
      "items": [
        {
          "id": 1,
          "menu_item_id": 1,
          "quantity": 2,
          "price": "250.00",
          "menu_item": {
            "id": 1,
            "name": "Овсяная каша",
            "image": "https://example.com/image.jpg"
          }
        }
      ]
    }
  ]
}
```

### POST /api/orders
Создание нового заказа

**Headers:**
```
Authorization: Bearer {token}
```

**Request:**
```json
{
  "items": [
    {
      "menu_item_id": 1,
      "quantity": 2
    },
    {
      "menu_item_id": 3,
      "quantity": 1
    }
  ],
  "delivery_address": "Казань, ул. Баумана, 10",
  "delivery_time": "14:00 - 15:00",
  "phone": "+79371234567",
  "comment": "Позвоните за 10 минут"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Заказ успешно создан",
  "data": {
    "id": 1,
    "user_id": 1,
    "total_amount": "750.00",
    "status": "pending",
    ...
  }
}
```

### GET /api/orders/{id}
Получение конкретного заказа

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "user_id": 1,
    "total_amount": "750.00",
    "status": "pending",
    "items": [...]
  }
}
```

---

## Консультации

### POST /api/consultations
Бронирование консультации

**Request:**
```json
{
  "name": "Иван Иванов",
  "email": "ivan@example.com",
  "phone": "+79371234567",
  "date": "2024-12-25",
  "time": "14:00:00",
  "message": "Хочу составить план питания"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Заявка на консультацию успешно создана",
  "data": {
    "id": 1,
    "name": "Иван Иванов",
    "email": "ivan@example.com",
    "phone": "+79371234567",
    "date": "2024-12-25",
    "time": "14:00:00",
    "message": "Хочу составить план питания",
    "status": "pending"
  }
}
```

### GET /api/consultations (Dietolog only)
Получение всех консультаций

**Headers:**
```
Authorization: Bearer {dietolog_token}
```

**Query Parameters:**
- `status` (optional) - фильтр по статусу (pending, scheduled, completed, cancelled)

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "user_id": 2,
      "name": "Иван Иванов",
      "email": "ivan@example.com",
      "phone": "+79371234567",
      "date": "2024-12-25",
      "time": "14:00:00",
      "message": "Хочу составить план питания",
      "status": "pending",
      "dietolog_id": null,
      "notes": null,
      "user": {
        "id": 2,
        "name": "Иван Иванов",
        "email": "ivan@example.com"
      }
    }
  ]
}
```

### PUT /api/consultations/{id} (Dietolog only)
Обновление консультации

**Headers:**
```
Authorization: Bearer {dietolog_token}
```

**Request:**
```json
{
  "status": "scheduled",
  "notes": "Консультация назначена"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Консультация успешно обновлена",
  "data": {
    "id": 1,
    "status": "scheduled",
    "notes": "Консультация назначена",
    ...
  }
}
```

---

## Примеры контроллеров

### MenuController.php

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MenuItem;
use Illuminate\Http\Request;

class MenuController extends Controller
{
    public function index(Request $request)
    {
        $query = MenuItem::query();

        if ($request->has('category')) {
            $query->category($request->category);
        }

        if ($request->has('available') && $request->available === 'true') {
            $query->available();
        }

        $items = $query->orderBy('category')->orderBy('name')->get();

        return response()->json([
            'success' => true,
            'data' => $items,
        ]);
    }

    public function show($id)
    {
        $item = MenuItem::findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $item,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'price' => 'required|numeric|min:0',
            'image' => 'required|string',
            'category' => 'required|in:завтрак,основное,напитки,десерты',
            'is_available' => 'boolean',
        ]);

        $item = MenuItem::create($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Блюдо успешно создано',
            'data' => $item,
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $item = MenuItem::findOrFail($id);

        $request->validate([
            'name' => 'string|max:255',
            'description' => 'string',
            'price' => 'numeric|min:0',
            'image' => 'string',
            'category' => 'in:завтрак,основное,напитки,десерты',
            'is_available' => 'boolean',
        ]);

        $item->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Блюдо успешно обновлено',
            'data' => $item,
        ]);
    }

    public function destroy($id)
    {
        $item = MenuItem::findOrFail($id);
        $item->delete();

        return response()->json([
            'success' => true,
            'message' => 'Блюдо успешно удалено',
        ]);
    }
}
```

### OrderController.php

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\MenuItem;
use App\Models\OrderItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class OrderController extends Controller
{
    public function index(Request $request)
    {
        $orders = Order::with(['items.menuItem'])
            ->forUser($request->user()->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $orders,
        ]);
    }

    public function show(Request $request, $id)
    {
        $order = Order::with(['items.menuItem'])
            ->forUser($request->user()->id)
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $order,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'items' => 'required|array|min:1',
            'items.*.menu_item_id' => 'required|exists:menu_items,id',
            'items.*.quantity' => 'required|integer|min:1',
            'delivery_address' => 'required|string|max:500',
            'delivery_time' => 'required|string|max:50',
            'phone' => 'required|string|max:20',
            'comment' => 'nullable|string',
        ]);

        DB::beginTransaction();
        try {
            // Создаем заказ
            $order = Order::create([
                'user_id' => $request->user()->id,
                'total_amount' => 0, // Будет пересчитан ниже
                'status' => 'pending',
                'delivery_address' => $request->delivery_address,
                'delivery_time' => $request->delivery_time,
                'phone' => $request->phone,
                'comment' => $request->comment,
            ]);

            $totalAmount = 0;

            // Создаем позиции заказа
            foreach ($request->items as $item) {
                $menuItem = MenuItem::findOrFail($item['menu_item_id']);

                OrderItem::create([
                    'order_id' => $order->id,
                    'menu_item_id' => $menuItem->id,
                    'quantity' => $item['quantity'],
                    'price' => $menuItem->price,
                ]);

                $totalAmount += $menuItem->price * $item['quantity'];
            }

            // Обновляем общую сумму
            $order->update(['total_amount' => $totalAmount]);

            DB::commit();

            // Загружаем заказ с позициями
            $order->load('items.menuItem');

            return response()->json([
                'success' => true,
                'message' => 'Заказ успешно создан',
                'data' => $order,
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json([
                'success' => false,
                'message' => 'Ошибка при создании заказа',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
```

### ConsultationController.php

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Consultation;
use Illuminate\Http\Request;

class ConsultationController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255',
            'phone' => 'required|string|max:20',
            'date' => 'required|date|after:today',
            'time' => 'required|date_format:H:i:s',
            'message' => 'nullable|string',
        ]);

        $consultation = Consultation::create([
            'user_id' => auth()->check() ? auth()->id() : null,
            'name' => $request->name,
            'email' => $request->email,
            'phone' => $request->phone,
            'date' => $request->date,
            'time' => $request->time,
            'message' => $request->message,
            'status' => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Заявка на консультацию успешно создана',
            'data' => $consultation,
        ], 201);
    }

    public function index(Request $request)
    {
        // Только для диетологов
        if (!$request->user()->isDietolog() && !$request->user()->isAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'Доступ запрещен',
            ], 403);
        }

        $query = Consultation::with('user');

        if ($request->has('status')) {
            $query->status($request->status);
        }

        $consultations = $query->orderBy('date')->orderBy('time')->get();

        return response()->json([
            'success' => true,
            'data' => $consultations,
        ]);
    }

    public function update(Request $request, $id)
    {
        // Только для диетологов
        if (!$request->user()->isDietolog() && !$request->user()->isAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'Доступ запрещен',
            ], 403);
        }

        $consultation = Consultation::findOrFail($id);

        $request->validate([
            'status' => 'in:pending,scheduled,completed,cancelled',
            'notes' => 'nullable|string',
        ]);

        $consultation->update([
            'status' => $request->status ?? $consultation->status,
            'notes' => $request->notes ?? $consultation->notes,
            'dietolog_id' => $request->user()->id,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Консультация успешно обновлена',
            'data' => $consultation,
        ]);
    }
}
```

---

## Routes

Создайте файл `routes/api.php`:

```php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\MenuController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\ConsultationController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Авторизация (публичные маршруты)
Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);

    // Защищенные маршруты
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('logout', [AuthController::class, 'logout']);
        Route::get('me', [AuthController::class, 'me']);
    });
});

// Меню (публичный доступ для чтения)
Route::get('menu', [MenuController::class, 'index']);
Route::get('menu/{id}', [MenuController::class, 'show']);

// Меню (только для администраторов)
Route::middleware(['auth:sanctum', 'admin'])->group(function () {
    Route::post('menu', [MenuController::class, 'store']);
    Route::put('menu/{id}', [MenuController::class, 'update']);
    Route::delete('menu/{id}', [MenuController::class, 'destroy']);
});

// Заказы (требует авторизации)
Route::middleware('auth:sanctum')->group(function () {
    Route::get('orders', [OrderController::class, 'index']);
    Route::get('orders/{id}', [OrderController::class, 'show']);
    Route::post('orders', [OrderController::class, 'store']);
});

// Консультации
Route::post('consultations', [ConsultationController::class, 'store']); // Публичный

// Консультации (только для диетологов)
Route::middleware(['auth:sanctum', 'dietolog'])->group(function () {
    Route::get('consultations', [ConsultationController::class, 'index']);
    Route::put('consultations/{id}', [ConsultationController::class, 'update']);
});
```

---

## Middleware

Создайте middleware для проверки ролей.

### app/Http/Middleware/AdminMiddleware.php

```php
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class AdminMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        if (!$request->user() || !$request->user()->isAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'Доступ запрещен. Требуются права администратора.',
            ], 403);
        }

        return $next($request);
    }
}
```

### app/Http/Middleware/DietologMiddleware.php

```php
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class DietologMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        if (!$request->user() || (!$request->user()->isDietolog() && !$request->user()->isAdmin())) {
            return response()->json([
                'success' => false,
                'message' => 'Доступ запрещен. Требуются права диетолога.',
            ], 403);
        }

        return $next($request);
    }
}
```

Зарегистрируйте middleware в `app/Http/Kernel.php`:

```php
protected $middlewareAliases = [
    // ...
    'admin' => \App\Http\Middleware\AdminMiddleware::class,
    'dietolog' => \App\Http\Middleware\DietologMiddleware::class,
];
```

---

## Seeders

### database/seeders/DatabaseSeeder.php

```php
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\MenuItem;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Создание пользователей
        User::create([
            'name' => 'Администратор',
            'email' => 'admin@zelen.ru',
            'password' => Hash::make('admin123'),
            'phone' => '+79371234567',
            'role' => 'admin',
        ]);

        User::create([
            'name' => 'Диетолог',
            'email' => 'dietolog@zelen.ru',
            'password' => Hash::make('dietolog123'),
            'phone' => '+79371234568',
            'role' => 'dietolog',
        ]);

        User::create([
            'name' => 'Тестовый пользователь',
            'email' => 'test@example.com',
            'password' => Hash::make('password'),
            'phone' => '+79371234569',
            'role' => 'user',
        ]);

        // Создание блюд меню
        $menuItems = [
            // Завтраки
            [
                'name' => 'Овсяная каша с ягодами',
                'description' => 'Полезный завтрак с овсянкой и свежими ягодами',
                'price' => 250,
                'image' => 'https://images.unsplash.com/photo-1517673132405-a56a62b18caf?w=400',
                'category' => 'завтрак',
            ],
            [
                'name' => 'Смузи боул',
                'description' => 'Ягодный смузи с гранолой и фруктами',
                'price' => 320,
                'image' => 'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=400',
                'category' => 'завтрак',
            ],
            // Основные блюда
            [
                'name' => 'Лосось с овощами',
                'description' => 'Запеченный лосось с гриль-овощами',
                'price' => 650,
                'image' => 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400',
                'category' => 'основное',
            ],
            [
                'name' => 'Куриная грудка с киноа',
                'description' => 'Нежная куриная грудка с киноа и зеленью',
                'price' => 480,
                'image' => 'https://images.unsplash.com/photo-1432139555190-58524dae6a55?w=400',
                'category' => 'основное',
            ],
            // Напитки
            [
                'name' => 'Зеленый смузи',
                'description' => 'Детокс смузи со шпинатом и яблоком',
                'price' => 280,
                'image' => 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
                'category' => 'напитки',
            ],
            // Десерты
            [
                'name' => 'Чиа пудинг',
                'description' => 'Десерт из семян чиа с манго',
                'price' => 300,
                'image' => 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
                'category' => 'десерты',
            ],
        ];

        foreach ($menuItems as $item) {
            MenuItem::create($item);
        }
    }
}
```

---

## Настройка CORS

В файле `config/cors.php`:

```php
<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['http://localhost:3000', 'http://127.0.0.1:3000'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => true,
];
```

---

## Файл .env

```env
APP_NAME="Zelen Restaurant API"
APP_ENV=local
APP_KEY=base64:... # php artisan key:generate
APP_DEBUG=true
APP_URL=http://localhost:3001

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=zelen_restaurant
DB_USERNAME=zelen_user
DB_PASSWORD=password

SANCTUM_STATEFUL_DOMAINS=localhost:3000,127.0.0.1:3000
SESSION_DRIVER=cookie
SESSION_DOMAIN=localhost
```

---

## Команды для запуска

```bash
# Генерация ключа приложения
php artisan key:generate

# Запуск миграций
php artisan migrate

# Запуск seeders
php artisan db:seed

# Очистка кэша
php artisan config:clear
php artisan cache:clear

# Запуск сервера
php artisan serve --port=3001
```

---

Готово! API полностью настроен и готов к работе с вашим React frontend.
