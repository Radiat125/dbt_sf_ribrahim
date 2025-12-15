{{
    config(
        materialized='table',
        unique_key='product_key',
        tags=['gold', 'dimension', 'product']
    )
}}

-- Gold Layer: Product Dimension (Type 1 SCD)

WITH silver_products AS (
    SELECT * FROM {{ ref('silver_products') }}
),

dimension_prod AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_key,
        product_id,
        product_name,
        supplier_id,
        unit_price,
        package,
        is_discontinued,
        silver_loaded_at AS effective_date,
        CURRENT_TIMESTAMP() AS gold_loaded_at
    FROM silver_products
)

SELECT * FROM dimension_prod