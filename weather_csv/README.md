Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


# Weather Data Pipeline
## Архитектура
- Источник: CSV -> Airbyte -> PostgreSQL
- Хранилище: PostgreSQL
- Трансформация: dbt

## Развертывание
1. Запустить Airbyte и настроить соединение
2. Выполнить `dbt run`


