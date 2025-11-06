<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\MenuItem;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
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
            // ЗАВТРАКИ
            [
                'name' => 'Сырники',
                'description' => 'Классические сырники с ягодным соусом',
                'price' => 320,
                'category' => 'завтрак',
                'image' => '/assets/img/Сырники.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Творожная запеканка',
                'description' => 'Нежная запеканка с изюмом',
                'price' => 290,
                'category' => 'завтрак',
                'image' => '/assets/img/творожная запеканка.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Рисовая каша на кокосовом молоке',
                'description' => 'Ароматная каша с кокосовым молоком',
                'price' => 280,
                'category' => 'завтрак',
                'image' => '/assets/img/Рисовая каша на кокосовом молоке.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Тост с авокадо и креветками',
                'description' => 'Хрустящий тост с авокадо и креветками',
                'price' => 420,
                'category' => 'завтрак',
                'image' => '/assets/img/Тост с авокадо и креветками.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Тост с форелью',
                'description' => 'Тост с слабосоленой форелью',
                'price' => 450,
                'category' => 'завтрак',
                'image' => '/assets/img/Тост с форелью.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Брускетта с авокадо',
                'description' => 'Итальянская брускетта с авокадо',
                'price' => 380,
                'category' => 'завтрак',
                'image' => '/assets/img/Брускетта с авокадо.jpeg',
                'is_available' => true,
            ],

            // ОСНОВНЫЕ БЛЮДА
            [
                'name' => 'Киноа боул с курицей и авокадо',
                'description' => 'Питательный боул с киноа, курицей и авокадо',
                'price' => 455,
                'category' => 'основное',
                'image' => '/assets/img/Киноа боул с курицей и авокадо.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Боул',
                'description' => 'Сбалансированный боул с овощами',
                'price' => 420,
                'category' => 'основное',
                'image' => '/assets/img/Боул.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Овощной салат с курицей',
                'description' => 'Свежий салат с куриной грудкой',
                'price' => 390,
                'category' => 'основное',
                'image' => '/assets/img/Овощной салат с курицей.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Салат с креветками',
                'description' => 'Легкий салат с тигровыми креветками',
                'price' => 520,
                'category' => 'основное',
                'image' => '/assets/img/Салат с креветками.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Салат с мидиями',
                'description' => 'Морской салат с мидиями',
                'price' => 480,
                'category' => 'основное',
                'image' => '/assets/img/Салат с мидиями.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Борщ',
                'description' => 'Традиционный борщ со сметаной',
                'price' => 350,
                'category' => 'основное',
                'image' => '/assets/img/Борщ.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Филе индейки',
                'description' => 'Запеченное филе индейки с овощами',
                'price' => 550,
                'category' => 'основное',
                'image' => '/assets/img/Филе индейки.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Филе куриное',
                'description' => 'Куриное филе на гриле',
                'price' => 480,
                'category' => 'основное',
                'image' => '/assets/img/Филе куриное.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Веганский жульен с грибами',
                'description' => 'Жульен с грибами без молочных продуктов',
                'price' => 420,
                'category' => 'основное',
                'image' => '/assets/img/Веганский жульен с грибами.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Фалафель и хумус',
                'description' => 'Веганское блюдо с фалафелем и хумусом',
                'price' => 390,
                'category' => 'основное',
                'image' => '/assets/img/Фалафель и хумус (для веганов).jpeg',
                'is_available' => true,
            ],

            // НАПИТКИ
            [
                'name' => 'Зеленый смузи',
                'description' => 'Освежающий смузи со шпинатом и бананом',
                'price' => 250,
                'category' => 'напитки',
                'image' => '/assets/img/Зеленый смузи.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Ягодный смузи',
                'description' => 'Смузи с лесными ягодами',
                'price' => 270,
                'category' => 'напитки',
                'image' => '/assets/img/Ягодный смузи.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Вода с лимоном и мятой',
                'description' => 'Детокс вода с лимоном и мятой',
                'price' => 150,
                'category' => 'напитки',
                'image' => '/assets/img/Вода с лимоном и мятой.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Зеленый чай с мятой',
                'description' => 'Ароматный зеленый чай',
                'price' => 180,
                'category' => 'напитки',
                'image' => '/assets/img/Зеленый чай с мятой.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Черный чай с мёдом и лимоном',
                'description' => 'Согревающий черный чай',
                'price' => 180,
                'category' => 'напитки',
                'image' => '/assets/img/Черный чай с мёдом и лимоном.jpeg',
                'is_available' => true,
            ],

            // ДЕСЕРТЫ
            [
                'name' => 'Шарлотка',
                'description' => 'Домашняя яблочная шарлотка',
                'price' => 250,
                'category' => 'десерты',
                'image' => '/assets/img/Шарлотка.jpeg',
                'is_available' => true,
            ],
            [
                'name' => 'Банановое парфе',
                'description' => 'Легкий десерт с бананом и йогуртом',
                'price' => 280,
                'category' => 'десерты',
                'image' => '/assets/img/Банановое парфе.jpeg',
                'is_available' => true,
            ],
        ];

        foreach ($menuItems as $item) {
            MenuItem::create($item);
        }

        $this->command->info('Database seeded successfully!');
        $this->command->info('Test users:');
        $this->command->info('Admin: admin@zelen.ru / admin123');
        $this->command->info('Dietolog: dietolog@zelen.ru / dietolog123');
        $this->command->info('User: test@example.com / password');
    }
}
