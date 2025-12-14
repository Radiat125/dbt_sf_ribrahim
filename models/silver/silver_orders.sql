{{
    config(
        materialized='view',
        tags=['silver', 'orders']
    )
}}

-- Silver Layer: Cleansed and conformed order data

WITH bronze_orders AS (
    SELECT * FROM {{ ref('bronze_orders') }}
),

cleansed_orders AS (
    SELECT
        order_id,
        order_date,
        NULLIF(TRIM(order_number), '') AS order_number,
        customer_id,
        COALESCE(total_amount, 0) AS total_amount,
        bronze_loaded_at,
        CURRENT_TIMESTAMP() AS silver_loaded_at
    FROM bronze_orders
    WHERE order_date IS NOT NULL  -- Filter out invalid orders
)

SELECT * FROM cleansed_orders