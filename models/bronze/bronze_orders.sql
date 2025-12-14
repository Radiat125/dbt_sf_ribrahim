{{
    config(
        materialized='view',
        tags=['bronze', 'orders']
    )
}}

SELECT
    Id AS order_id,
    OrderDate AS order_date,
    OrderNumber AS order_number,
    CustomerId AS customer_id,
    TotalAmount AS total_amount,
    CURRENT_TIMESTAMP() AS bronze_loaded_at
FROM {{ source('oltp_source', 'Order') }}