# Adal CRM - iOS Mobile App

Мобильное приложение для системы управления заказами Adal CRM.

## Особенности

### 🎨 Минималистичный дизайн
- Цветовая схема: черный, оранжевый, белый
- Чистый и современный интерфейс
- Использование системных иконок SF Symbols
- Адаптивная верстка для всех размеров экранов

### 📱 Функциональность

#### Для всех ролей:
- **Авторизация** - безопасный вход в систему
- **Просмотр заказов** - список заказов с фильтрацией по статусам
- **Детали заказа** - подробная информация о заказе
- **Статистика** - персональная статистика работы
- **Профиль** - информация о пользователе

#### Для курьеров:
- Отметка заказов как "Забранный"
- Отметка заказов как "Доставленный"
- Просмотр всех назначенных заказов

#### Для мойщиков:
- Отметка заказов как "Постиранный"
- Просмотр заказов в стирке

#### Для помощников мойщика:
- Отметка заказов как "Высушенный и упакованный"
- Просмотр заказов после стирки

### 🎯 Цветовая схема статусов
- **Красные** (не взяты): Создан, Назначен
- **Зеленые** (в работе): Забран, В стирке, Постиран, Высушен и упакован, Готов к доставке
- **Черный** (завершено): Доставлен
- **Серый** (отменено): Отменен

## Структура проекта

```
mobile/
├── AdalCRM/
│   ├── Models/
│   │   ├── User.swift          # Модели пользователей
│   │   └── Order.swift         # Модели заказов
│   ├── Services/
│   │   ├── AuthService.swift   # Сервис авторизации
│   │   └── APIService.swift    # API клиент
│   ├── Views/
│   │   ├── LoginViewController.swift
│   │   ├── OrdersViewController.swift
│   │   ├── OrderTableViewCell.swift
│   │   ├── OrderDetailViewController.swift
│   │   ├── StatisticsViewController.swift
│   │   └── ProfileViewController.swift
│   ├── Assets.xcassets/
│   │   └── Adal logo2.imageset/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── Info.plist
└── README.md
```

## Установка и настройка

### Требования
- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

### Настройка проекта

1. **Скопируйте логотип**:
   ```bash
   cp "Adal logo2.jpg" mobile/AdalCRM/Assets.xcassets/Adal\ logo2.imageset/
   ```

2. **Настройте URL API**:
   В файлах `AuthService.swift` и `APIService.swift` измените `baseURL` на ваш сервер:
   ```swift
   private let baseURL = "http://your-server.com/api"
   ```

3. **Откройте проект в Xcode**:
   ```bash
   open mobile/AdalCRM.xcodeproj
   ```

### Создание Xcode проекта

Если вы хотите создать проект с нуля:

1. Откройте Xcode
2. Создайте новый проект: File → New → Project
3. Выберите iOS → App
4. Настройки проекта:
   - Product Name: `AdalCRM`
   - Bundle Identifier: `com.adal.crm`
   - Language: Swift
   - Interface: Storyboard
   - Use Core Data: No

5. Скопируйте все файлы из папки `mobile/AdalCRM/` в ваш проект

## API Endpoints

Приложение использует следующие API endpoints:

### Авторизация
- `POST /api/auth/login/` - Вход в систему

### Заказы
- `GET /api/orders/` - Список заказов (для менеджеров/директоров)
- `GET /api/courier/orders/` - Заказы курьера
- `GET /api/washer/orders/` - Заказы мойщика
- `GET /api/washer-assistant/orders/` - Заказы помощника мойщика

### Обновление статусов
- `POST /api/courier/orders/{id}/update-status/` - Обновление статуса курьером
- `POST /api/washer/orders/{id}/complete/` - Завершение стирки
- `POST /api/washer-assistant/orders/{id}/update-status/` - Обновление статуса помощником

### Статистика
- `GET /api/courier/statistics/` - Статистика курьера
- `GET /api/washer/statistics/` - Статистика мойщика
- `GET /api/washer-assistant/statistics/` - Статистика помощника

## Тестовые пользователи

- **Директор**: `director` / `password123`
- **Менеджер**: `manager1` / `password123`
- **Курьер**: `courier1` / `password123`
- **Мойщик**: `washer1` / `password123`
- **Помощник мойщика**: `assistant1` / `password123`

## Особенности реализации

### Архитектура
- **MVC** - классическая архитектура iOS приложений
- **Singleton Services** - для управления авторизацией и API
- **Programmatic UI** - интерфейс создан программно без Storyboard

### Безопасность
- JWT токены для авторизации
- Автоматическое сохранение токенов в UserDefaults
- Проверка прав доступа на уровне UI

### UX/UI
- Pull-to-refresh для обновления данных
- Индикаторы загрузки
- Обработка ошибок с понятными сообщениями
- Адаптивная верстка с Auto Layout

## Развитие проекта

### Планируемые функции
- Push-уведомления о новых заказах
- Офлайн режим с синхронизацией
- Сканер QR-кодов для заказов
- Фотографии заказов
- Геолокация для курьеров

### Технические улучшения
- Миграция на SwiftUI
- Добавление Core Data для кэширования
- Интеграция с системными уведомлениями
- Поддержка Dark Mode
