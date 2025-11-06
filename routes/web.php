<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json([
        'app' => 'Zelen Restaurant API',
        'version' => app()->version(),
        'status' => 'running'
    ]);
});
