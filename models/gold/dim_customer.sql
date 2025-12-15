{{
    config(
        materialized='table',
        unique_key='customer_key',
        tags=['gold', 'dimension', 'customer']
    )
}}

-- Gold Layer: Customer Dimension (Type 1 SCD)

WITH silver_customers AS (
    SELECT * FROM {{ ref('silver_customers') }}
),

dimension_cust AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['customer_id']) }} AS customer_key,
        customer_id,
        first_name,
        last_name,
        full_name,
        city,
        country,
        phone,
        silver_loaded_at AS effective_date,
        CURRENT_TIMESTAMP() AS gold_loaded_at
    FROM silver_customers
)

SELECT * FROM dimension_cust