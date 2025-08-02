# Руководство по подготовке Adal CRM к App Store

## 🚀 Пошаговая инструкция

### Шаг 1: Подготовка Apple Developer Account
1. **Зарегистрируйтесь в Apple Developer Program** ($99/год)
   - Перейдите на https://developer.apple.com
   - Выберите "Enroll" и следуйте инструкциям
   - Подтвердите личность и оплатите членство

2. **Настройте команду разработки**
   - Добавьте необходимых участников
   - Назначьте роли (Admin, Developer, etc.)

### Шаг 2: Настройка Bundle ID и Certificates

1. **Создайте App ID**
   ```
   Bundle ID: com.adal.crm
   App Name: Adal CRM
   Description: Order Management System
   ```

2. **Создайте Certificates**
   - iOS Development Certificate (для тестирования)
   - iOS Distribution Certificate (для App Store)

3. **Создайте Provisioning Profiles**
   - Development Profile (для разработки)
   - App Store Distribution Profile (для релиза)

### Шаг 3: Настройка проекта в Xcode

1. **Откройте проект**
   ```bash
   cd /Users/zainab/Desktop/adal/mobile
   open AdalCRM.xcodeproj
   ```

2. **Настройте Signing & Capabilities**
   - Выберите ваш Team
   - Bundle Identifier: `com.adal.crm`
   - Provisioning Profile: Automatic

3. **Обновите версию**
   - Version: 1.0.0
   - Build: 1

### Шаг 4: Создание иконок приложения

**Необходимые размеры иконок:**
- 20x20 (2x, 3x) - Notification
- 29x29 (2x, 3x) - Settings
- 40x40 (2x, 3x) - Spotlight
- 60x60 (2x, 3x) - App Icon
- 76x76 (1x, 2x) - iPad
- 83.5x83.5 (2x) - iPad Pro
- 1024x1024 (1x) - App Store

**Инструкция по созданию:**
1. Используйте ваш логотип "Adal logo2.jpg"
2. Создайте квадратную версию с отступами
3. Используйте онлайн генератор иконок (например, appicon.co)
4. Поместите все размеры в `Assets.xcassets/AppIcon.appiconset/`

### Шаг 5: Создание скриншотов

**Необходимые размеры:**
- iPhone 6.7": 1290 x 2796 pixels
- iPhone 6.5": 1242 x 2688 pixels  
- iPhone 5.5": 1242 x 2208 pixels
- iPad Pro 12.9": 2048 x 2732 pixels

**Рекомендуемые скриншоты:**
1. **Экран входа** - показать логотип и форму
2. **Список заказов** - разные статусы
3. **Детали заказа** - полная информация
4. **Статистика** - графики и цифры
5. **Профиль пользователя** - персональные данные

### Шаг 6: Настройка App Store Connect

1. **Создайте новое приложение**
   - Войдите в https://appstoreconnect.apple.com
   - Apps → "+" → New App
   - Заполните основную информацию

2. **Заполните метаданные**
   - App Name: "Adal CRM"
   - Subtitle: "Система управления заказами"
   - Description: (используйте из metadata.md)
   - Keywords: "CRM, заказы, управление, бизнес"
   - Category: Business
   - Content Rights Age Rating: 4+

3. **Загрузите медиа**
   - App Icon (1024x1024)
   - Screenshots для всех размеров
   - App Preview (опционально)

### Шаг 7: Настройка конфиденциальности

1. **App Privacy**
   - Data Types Collected:
     - Contact Info (Email, Phone)
     - Identifiers (User ID)
     - Usage Data (App Interactions)
   
   - Data Use:
     - App Functionality
     - Analytics
   
   - Data Sharing: No third-party sharing

2. **Age Rating**
   - Unrestricted Web Access: No
   - Gambling: No
   - Contests: No
   - Rating: 4+

### Шаг 8: Подготовка к релизу

1. **Обновите URL сервера**
   ```swift
   // В AuthService.swift и APIService.swift
   private let baseURL = "https://your-production-server.com/api"
   ```

2. **Тестирование**
   - Протестируйте на реальных устройствах
   - Проверьте все функции
   - Убедитесь в стабильности

3. **Archive и Upload**
   ```
   1. Product → Archive
   2. Organizer → Distribute App
   3. App Store Connect
   4. Upload
   ```

### Шаг 9: Отправка на ревью

1. **Заполните информацию для ревью**
   - Demo Account:
     - Username: courier1
     - Password: password123
   
   - Review Notes:
     "Приложение для корпоративного использования. 
     Требует авторизации. Используйте тестовый аккаунт 
     для ревью. Разные роли имеют разный функционал."

2. **Submit for Review**
   - Проверьте все поля
   - Нажмите "Submit for Review"

### Шаг 10: Ожидание и мониторинг

1. **Время ревью:** 24-48 часов
2. **Статусы:**
   - Waiting for Review
   - In Review  
   - Pending Developer Release
   - Ready for Sale

3. **Возможные причины отклонения:**
   - Неработающие функции
   - Проблемы с дизайном
   - Нарушение Guidelines
   - Проблемы с метаданными

## 📋 Чек-лист перед отправкой

### Технические требования
- [ ] Приложение запускается без ошибок
- [ ] Все экраны работают корректно
- [ ] Авторизация функционирует
- [ ] API подключение стабильно
- [ ] Нет крашей или зависаний
- [ ] Поддержка всех размеров экранов
- [ ] Корректная работа на iOS 13.0+

### Контент и дизайн
- [ ] Все иконки в нужных размерах
- [ ] Скриншоты высокого качества
- [ ] Launch Screen настроен
- [ ] Описание приложения заполнено
- [ ] Ключевые слова добавлены
- [ ] Возрастной рейтинг установлен

### Правовые аспекты
- [ ] Privacy Policy создана
- [ ] Terms of Service (если нужны)
- [ ] Права на использование логотипа
- [ ] Соответствие App Store Guidelines

### Метаданные
- [ ] Название приложения
- [ ] Подзаголовок
- [ ] Описание
- [ ] Ключевые слова
- [ ] Категория
- [ ] Контактная информация

## 🔧 Полезные инструменты

### Генераторы иконок
- https://appicon.co
- https://makeappicon.com
- https://icon.kitchen

### Создание скриншотов
- Xcode Simulator
- Screenshot Framer
- App Store Screenshot Generator

### Тестирование
- TestFlight (для бета-тестирования)
- Xcode Instruments (для профилирования)
- Device Console (для отладки)

## 📞 Поддержка

При возникновении проблем:
1. Apple Developer Forums
2. Apple Developer Support
3. Stack Overflow
4. iOS Dev Community

**Удачи с релизом! 🚀**
