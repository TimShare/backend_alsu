<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Consultation;
use Illuminate\Http\Request;

class ConsultationController extends Controller
{
    /**
     * Создание заявки на консультацию (публичный доступ)
     */
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

    /**
     * Получение всех консультаций (только диетолог)
     */
    public function index(Request $request)
    {
        // Проверка прав доступа
        if (!$request->user()->isDietolog() && !$request->user()->isAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'Доступ запрещен',
            ], 403);
        }

        $query = Consultation::with('user');

        // Фильтр по статусу
        if ($request->has('status')) {
            $query->status($request->status);
        }

        $consultations = $query->orderBy('date')->orderBy('time')->get();

        return response()->json([
            'success' => true,
            'data' => $consultations,
        ]);
    }

    /**
     * Обновление консультации (только диетолог)
     */
    public function update(Request $request, $id)
    {
        // Проверка прав доступа
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
