<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class DietologMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
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
