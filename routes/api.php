<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\MenuController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\ConsultationController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Авторизация (публичные маршруты)
Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);

    // Защищенные маршруты авторизации
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

// Заказы (только для администраторов)
Route::middleware(['auth:sanctum', 'admin'])->group(function () {
    Route::put('orders/{id}', [OrderController::class, 'update']);
});

// Консультации (публичное создание)
Route::post('consultations', [ConsultationController::class, 'store']);

// Консультации (только для диетологов и админов)
Route::middleware(['auth:sanctum', 'dietolog'])->group(function () {
    Route::get('consultations', [ConsultationController::class, 'index']);
    Route::put('consultations/{id}', [ConsultationController::class, 'update']);
});

// Тестовый маршрут
Route::get('/', function () {
    return response()->json([
        'message' => 'Zelen Restaurant API',
        'version' => '1.0.0',
        'status' => 'active',
    ]);
});
