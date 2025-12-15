{{
    config(
        materialized='table',
        unique_key='sales_key',
        tags=['gold', 'fact', 'sales']
    )
}}

-- Gold Layer: Sales Fact Table
-- One row per order line item
-- Contains all measures and foreign keys to dimensions

WITH silver_order_items AS (
    SELECT * FROM {{ ref('silver_order_items') }}
),

silver_orders AS (
    SELECT * FROM {{ ref('silver_orders') }}
),

silver_products AS (
    SELECT * FROM {{ ref('silver_products') }}
),

silver_customers AS (
    SELECT * FROM {{ ref('silver_customers') }}
),

dim_customer AS (
    SELECT * FROM {{ ref('dim_customer') }}
),

dim_product AS (
    SELECT * FROM {{ ref('dim_product') }}
),

dim_supplier AS (
    SELECT * FROM {{ ref('dim_supplier') }}
),

-- Joining all source data
fact_prep AS (
    SELECT
        oi.order_item_id,
        o.order_id,
        o.order_date,
        o.customer_id,
        p.product_id,
        p.supplier_id,
        oi.quantity,
        oi.unit_price,
        oi.line_total
    FROM silver_order_items oi
    INNER JOIN silver_orders o
        ON oi.order_id = o.order_id
    INNER JOIN silver_products p
        ON oi.product_id = p.product_id
    INNER JOIN silver_customers c
        ON o.customer_id = c.customer_id
),

-- Add surrogate keys from dim tables
fact_with_keys AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['fp.order_item_id']) }} AS sales_key,
        fp.order_id,
        fp.order_item_id,
        dc.customer_key,
        dp.product_key,
        ds.supplier_key,
        YEAR(fp.order_date) * 10000 + MONTH(fp.order_date) * 100 + DAY(fp.order_date) AS date_key,
        fp.quantity,
        fp.unit_price,
        fp.line_total,
        CURRENT_TIMESTAMP() AS gold_loaded_at
    FROM fact_prep fp
    INNER JOIN dim_customer dc
        ON fp.customer_id = dc.customer_id
    INNER JOIN dim_product dp
        ON fp.product_id = dp.product_id
    INNER JOIN dim_supplier ds
        ON fp.supplier_id = ds.supplier_id
)

SELECT * FROM fact_with_keys