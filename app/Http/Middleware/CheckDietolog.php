<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class CheckDietolog
{
    public function handle(Request $request, Closure $next)
    {
        if (!$request->user() || $request->user()->role !== 'dietolog') {
            return response()->json(['message' => 'Access denied. Dietolog role required.'], 403);
        }

        return $next($request);
    }
}
