{{
    config(
        materialized='view',
        tags=['silver', 'order_items']
    )
}}

-- Silver Layer: Cleansed and conformed order item data
-- Transformations:
-- - Calculate line totals
-- - Ensure positive quantities
-- - Validate pricing

WITH bronze_order_items AS (
    SELECT * FROM {{ ref('bronze_order_items') }}
),

cleansed_items AS (
    SELECT
        order_item_id,
        order_id,
        product_id,
        unit_price,
        quantity,
        unit_price * quantity AS line_total,
        bronze_loaded_at,
        CURRENT_TIMESTAMP() AS silver_loaded_at
    FROM bronze_order_items
    WHERE quantity > 0  -- Ensure positive quantities
      AND unit_price >= 0  -- Ensure non-negative prices
)

SELECT * FROM cleansed_items