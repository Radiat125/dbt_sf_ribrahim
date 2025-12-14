{{
    config(
        materialized='view',
        tags=['silver', 'products']
    )
}}

-- Silver Layer: Cleansed and conformed product data
-- Transformations:
-- - Ensure unit_price is non-negative
-- - Trim product names
-- - Validate supplier relationships

WITH bronze_products AS (
    SELECT * FROM {{ ref('bronze_products') }}
),

cleansed_prod AS (
    SELECT
        product_id,
        TRIM(product_name) AS product_name,
        supplier_id,
        CASE
            WHEN unit_price < 0 THEN 0
            ELSE unit_price
        END AS unit_price,
        NULLIF(TRIM(package), '') AS package,
        COALESCE(is_discontinued, FALSE) AS is_discontinued,
        bronze_loaded_at,
        CURRENT_TIMESTAMP() AS silver_loaded_at
    FROM bronze_products
)

SELECT * FROM cleansed_prod