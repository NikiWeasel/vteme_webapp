# vteme_tg_miniapp

Веб приложение для записи клиентов в парикмахерскую, предусмотрена интеграция в Telegram.

## Средства разработки

В проекте используются ключевые библиотеки:

- [google_fonts](https://pub.dev/packages/google_fonts) — подключение шрифтов Google.
- [go_router](https://pub.dev/packages/go_router) — современный маршрутизатор для Flutter.
- [firebase_core](https://pub.dev/packages/firebase_core),  
  [firebase_storage](https://pub.dev/packages/firebase_storage),  
  [cloud_firestore](https://pub.dev/packages/cloud_firestore) — интеграция с Firebase (база данных,
  хранилище, core).
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) — управление состоянием (BLoC/Cubit).
- [carousel_slider](https://pub.dev/packages/carousel_slider) — создание слайдеров и каруселей.
- [url_launcher](https://pub.dev/packages/url_launcher) — открытие ссылок и приложений.
- [telegram_web_app](https://pub.dev/packages/telegram_web_app) — интеграция с Telegram Web Apps.
- [intl](https://pub.dev/packages/intl) — интернационализация и работа с датами/числами.
- [mask_text_input_formatter](https://pub.dev/packages/mask_text_input_formatter) — маски для ввода
  текста.
- [translit](https://pub.dev/packages/translit) — транслитерация строк.
- [flutter_markdown](https://pub.dev/packages/flutter_markdown) — рендеринг Markdown в Flutter.

## Главный экран

Главный экран клиентского веб приложения состоит из секций специалистов и услуг.
Пользователь может просматривать портфолио, описание и записаться к выбранному специалисту.

Пользовательский интерфейс адаптивен и автоматически перестраивается для узких экранов путем
перемещения и уменьшения элементов интерфейса. В мобильной версии при отсутствии описания, контейнер
с ним полностью скрывается.
Реализация адаптивности выполнена через MediaQuery.

| ![1.png](https://raw.githubusercontent.com/NikiWeasel/readme_pics/refs/heads/main/tg_web_app/1.png) | ![2.png](https://raw.githubusercontent.com/NikiWeasel/readme_pics/refs/heads/main/tg_web_app/2.png) |
|-----------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|

## Экран записи

Экран записи открывается через кнопку «Записаться» и ведёт пользователя через выбор услуг,
специалиста, времени и ввод контактной информации.
Существует ограничение по количеству выбранных услуг: выбрать больше трех нельзя.

На экране выбора времени при предварительном выборе нескольких услуг можно записаться на них в
разное время.
Последним пунктом в записи необходимо отправить контактную информацию.

| ![3.png](https://raw.githubusercontent.com/NikiWeasel/readme_pics/refs/heads/main/tg_web_app/3.png) | ![4.png](https://raw.githubusercontent.com/NikiWeasel/readme_pics/refs/heads/main/tg_web_app/4.png) |
|-----------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
