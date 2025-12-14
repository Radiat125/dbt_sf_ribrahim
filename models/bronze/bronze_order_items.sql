{{
    config(
        materialized='view',
        tags=['bronze', 'order_items']
    )
}}

SELECT
    Id AS order_item_id,
    OrderId AS order_id,
    ProductId AS product_id,
    UnitPrice AS unit_price,
    Quantity AS quantity,
    CURRENT_TIMESTAMP() AS bronze_loaded_at
FROM {{ source('oltp_source', 'OrderItem') }}