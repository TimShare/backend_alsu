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
    /**
     * Получение заказов пользователя
     */
    public function index(Request $request)
    {
        $query = Order::with(['items.menuItem', 'user']);

        // Если пользователь не администратор, показываем только его заказы
        if (!$request->user()->isAdmin()) {
            $query->forUser($request->user()->id);
        }

        $orders = $query->orderBy('created_at', 'desc')->get();

        return response()->json([
            'success' => true,
            'data' => $orders,
        ]);
    }

    /**
     * Получение конкретного заказа
     */
    public function show(Request $request, $id)
    {
        $query = Order::with(['items.menuItem', 'user']);

        // Если пользователь не администратор, проверяем что заказ принадлежит ему
        if (!$request->user()->isAdmin()) {
            $query->forUser($request->user()->id);
        }

        $order = $query->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $order,
        ]);
    }

    /**
     * Создание нового заказа
     */
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

    /**
     * Обновление статуса заказа (только для администраторов)
     */
    public function update(Request $request, $id)
    {
        // Проверка прав доступа
        if (!$request->user()->isAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'Доступ запрещен. Только администраторы могут изменять статус заказа.',
            ], 403);
        }

        $order = Order::findOrFail($id);

        $request->validate([
            'status' => 'required|in:pending,confirmed,preparing,ready,delivered,cancelled',
        ]);

        $order->update([
            'status' => $request->status,
        ]);

        // Загружаем связанные данные
        $order->load(['items.menuItem', 'user']);

        return response()->json([
            'success' => true,
            'message' => 'Статус заказа успешно обновлен',
            'data' => $order,
        ]);
    }
}
