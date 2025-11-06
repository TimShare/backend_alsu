<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MenuItem;
use Illuminate\Http\Request;

class MenuController extends Controller
{
    /**
     * Получение всех блюд меню
     */
    public function index(Request $request)
    {
        $query = MenuItem::query();

        // Фильтр по категории
        if ($request->has('category')) {
            $query->category($request->category);
        }

        // Фильтр по доступности
        if ($request->has('available') && $request->available === 'true') {
            $query->available();
        }

        $items = $query->orderBy('category')->orderBy('name')->get();

        return response()->json([
            'success' => true,
            'data' => $items,
        ]);
    }

    /**
     * Получение конкретного блюда
     */
    public function show($id)
    {
        $item = MenuItem::findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $item,
        ]);
    }

    /**
     * Создание нового блюда (только админ)
     */
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

    /**
     * Обновление блюда (только админ)
     */
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

    /**
     * Удаление блюда (только админ)
     */
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
