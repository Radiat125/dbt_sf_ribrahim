{{
    config(
        materialized='table',
        unique_key='date_key',
        tags=['gold', 'dimension', 'date']
    )
}}

-- Gold/Analytics Layer: Date Dimension

WITH date_spine AS (
    {{
        dbt_utils.date_spine(
            datepart="day",
            start_date="cast('2010-01-01' as date)",
            end_date="cast('2030-12-31' as date)"
        )
    }}
),

dim_date AS (
    SELECT
        TO_NUMBER(TO_VARCHAR(date_day, 'YYYYMMDD')) AS date_key,
        date_day AS date,
        EXTRACT(DAY FROM date_day) AS day,
        EXTRACT(MONTH FROM date_day) AS month,
        EXTRACT(YEAR FROM date_day) AS year,
        EXTRACT(QUARTER FROM date_day) AS quarter,
        DAYNAME(date_day) AS day_name,
        MONTHNAME(date_day) AS month_name,
        CASE WHEN DAYOFWEEK(date_day) IN (0, 6) THEN TRUE ELSE FALSE END AS is_weekend,
        CURRENT_TIMESTAMP() AS gold_loaded_at
    FROM date_spine
)

SELECT * FROM dim_date