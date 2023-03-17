# Домашняя работа №5
В этой домашней работе закрепляем знания полученные на лекции **Multithreading**

### Задание:
Метод `fetchImage` у класса `ViewModel` работает так долго, что приложение запускается 10 секунд. Это неприемлимо!

Доработайте метод так, чтобы:
1) Приложение запускалось моментально
2) Одновременно экспортировалось не более 3-х изображений (снижаем нагрузку на процессор)
3) Повторно запрошенное изображение не экспортировалось заново (еще сильнее оптимизируем затрачиваемые ресурсы, требуется кеш)

### Разрешенные инструменты:
- Grand Central Dispatch (GCD)
- OperationQueue

Если у вас получится, то можно вас поздравить. Вы успешно справились с одной из самых популярных задач с собеседований!

|   |   |
|-|-|
|__Срок выполнения__| 23.12.2022 |
| __Название лейбла__ | Homework5 |
| __Цвет лейбла__ | #9300c5 |