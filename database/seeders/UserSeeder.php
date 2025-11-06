<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run()
    {
        $users = [
            [
                'name' => 'Администратор',
                'email' => 'admin@zelen.ru',
                'password' => Hash::make('admin123'),
                'role' => 'admin',
                'phone' => '+7 (937) 525-21-72',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Диетолог Алсу',
                'email' => 'dietolog@zelen.ru',
                'password' => Hash::make('dietolog123'),
                'role' => 'dietolog',
                'phone' => '+7 (937) 525-21-72',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ];

        // Проверяем, не существуют ли уже эти пользователи
        foreach ($users as $user) {
            $exists = DB::table('users')->where('email', $user['email'])->exists();
            if (!$exists) {
                DB::table('users')->insert($user);
            }
        }
    }
}
