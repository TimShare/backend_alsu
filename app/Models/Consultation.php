<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Consultation extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'email',
        'phone',
        'date',
        'time',
        'message',
        'status',
        'dietolog_id',
        'notes',
    ];

    protected $casts = [
        'date' => 'date',
    ];

    /**
     * Scope для фильтрации по статусу
     */
    public function scopeStatus($query, $status)
    {
        return $query->where('status', $status);
    }

    /**
     * Scope для консультаций диетолога
     */
    public function scopeForDietolog($query, $dietologId)
    {
        return $query->where('dietolog_id', $dietologId);
    }

    /**
     * Отношения
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function dietolog()
    {
        return $this->belongsTo(User::class, 'dietolog_id');
    }
}
