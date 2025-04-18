{{config(materialized='table')}}

select
    date_trunc('day', loaded_at) as date,
    avg(temperature_c) as avg_temp,
    max(temperature_c) as max_temp,
    min(temperature_c) as min_temp,
    avg(humidity_pct) as avg_humidity
from {{ ref('stg_airbyte_raw') }}
group by 1