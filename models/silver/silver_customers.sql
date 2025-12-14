{{
    config(
        materialized='view',
        tags=['silver', 'customers']
    )
}}

-- Silver Layer: Cleaned and conformed customer data
-- Transformations:
-- - Trim whitespace from text fields
-- - Create full_name field
-- - Standardize null handling,
-- - Add data quality metadata

WITH bronze_customers AS (
    SELECT * FROM {{ ref('bronze_customers') }}
),

cleansed_cust AS (
    SELECT
        customer_id,
        TRIM(first_name) AS first_name,
        TRIM(last_name) AS last_name,
        TRIM(first_name) || ' ' || TRIM(last_name) AS full_name,
        NULLIF(TRIM(city), '') AS city,
        NULLIF(TRIM(country), '') AS country,
        NULLIF(TRIM(phone), '') AS phone,
        bronze_loaded_at,
        CURRENT_TIMESTAMP() AS silver_loaded_at
    FROM bronze_customers
)

SELECT * FROM cleansed_cust