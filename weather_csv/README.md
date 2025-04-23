# Пайплайн обработки метеоданных (CSV → Airbyte → PostgreSQL → dbt)

## 📌 Описание проекта
ETL-процесс для загрузки и анализа метеорологических данных:
1. **Загрузка**: CSV-файл → Airbyte → PostgreSQL (сырые данные)
2. **Трансформация**: Очистка и агрегация через dbt
3. **Аналитика**: Готовые datasets для визуализации

## 🛠 Технологический стек
- **Airbyte** (версия 1.6.0) - извлечение и загрузка данных
- **PostgreSQL** (версия 17) - хранение данных
- **dbt Core** (версия 1.9.0) - трансформация данных

## 🪛 Описание моделей
- **models/stagging** 
  + Приводит сырые данные из Airbyte к стандартному формату
  + Проводит базовые проверки качества (тесты на NULL, диапазоны)
  + Переименовывает колонки (например, *Outdoor_Drybulb_Temperature__C_* → *temperature_c*)
- **models/marts** 
  + Агрегирует данные (по дням)
  + Считает метрики (avg_temp, min_temp, max_temp, avg_humidity)
  + Формирует удобную структуру для дальнейшего анализа



## 🚀 Гайд по началу работы
1. Скачать Docker [Docker](https://www.docker.com/products/docker-desktop/)
2. Установить Airbyte [Гайд по установке Airbyte](https://docs.airbyte.com/using-airbyte/getting-started/oss-quickstart)
3. Установить PostgreSQL [PostgreSQL](https://www.postgresql.org/download/)
4. Настроить Source в Airbyte. В нашем случае CSV.
   + Source name: CSV File
   + Dataset Name: csv_weather
   + File Format: csv
   + Storage Provider: HTTPS: Public Web
   + URL: (https://drive.google.com/uc?export=download&id=1t9cmZ86Tn3TJh5d1lrAFJzhp8-nUsBqi)
   + Нажать Test and save.
5. Настроить Destination в Airbyte. В нашем случае PostgreSQL.
    + Destination name: Postgres
    + Host: Ваш ip
    + Port: 5432 (стандартный порт PostgreSQL)
    + DB Name: WeatherCSV (нужно будет перед этим создать в PostgreSQL базу данных с таким названием)
    + Default Schema: public
    + User: postgres
    + SSL modes: disable
    + SSH Tunnel Method: No Tunnel
    + Password: postgres
    + Возможна проблема с C:\Program Files\PostgreSQL\17\data\pg_hba.conf. Его нужно открыть блокнотом и вставить в конец (host    Название_БД   Имя_user        ваш_ip/32         md5)
    + Нажать Test and save.
6. В Connections нажимаем **+ new connection**. Далее выбираем созданные ранее Source и Destination, ждем окончания создания.
    + Connection name: CSV File → Postgres
    + Schedule type: Manual
    + Destination Namespace: Destination-defined
    + Stream Prefix Optional: src_
    + Detect and propagate schema changes: Propagate field changes only
    + Также во вкладке **Schema** в **Sync mode** поставить **Full refresh | Append** 
7. Cинхронизируем данные в Connection, нажав **Sync now**. После этого данные появятся у нас в БД. ![Данные в БД](/screenshot/src_csv_weather.png)
8. Устанавливаем dbt (**Версия dbt Core должна совпадать с версией dbt Plugins postgres**).
9. Далее в C:/Users/Имя_пользователя/.dbt/profiles.yml настраиваем
    + weather_csv:
    + outputs:
        + dev:
        + dbname: WeatherCSV
        + host: ip
        + pass: postgres
        + port: 5432
        + schema: analytics
        + threads: 4
        + type: postgres
        + user: postgres
    + target: dev
10. Запускаем `dbt run`. ![dbt run](/screenshot/dbt_run.png)
11. Запускаем `dbt test`. ![dbt test](/screenshot/dbt_test.png)
12. Если всё сделано верно, то в БД появятся 2 новые схемы(analytics_marts и analytics_stagging).
**analytics_stagging**:
![analytics_stagging](/screenshot/analytics_stagging.png)
**analytics_marts**: ![analytics_marts](/screenshot/analytics_marts.png)
