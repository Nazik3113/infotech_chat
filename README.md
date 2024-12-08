# InfotechChat

Тестове завдання для компанії `"ІНФОТЕХ"`, `ЧАТ` на мові програмування `Elixir`, що написаний за допомогою бібліотек `n2o` та `nitro`.

# Підняття проекту локально

- Збираємо через `Dockerfile` та `docker-compose`.
    - Виконайте команду `docker-compose up --build` або також може бути `docker compose up --build`, в залежності від вашого Docker середовища.

- Звичайний сценарій запуску проекту локально.
    - Залежності - `mix deps.get && mix deps.compile && mix compile`.
    - Запуск сервера - `iex -S mix`.

# Використання

- Відкрийте `http://localhost:8004/index.html`
