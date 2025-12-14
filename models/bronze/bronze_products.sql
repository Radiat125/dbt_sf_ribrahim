{{
    config(
        materialized='view',
        tags=['bronze', 'products']
    )
}}

SELECT
    Id AS product_id,
    ProductName AS product_name,
    SupplierId AS supplier_id,
    UnitPrice AS unit_price,
    Package AS package,
    IsDiscontinued AS is_discontinued,
    CURRENT_TIMESTAMP() AS bronze_loaded_at
FROM {{ source('oltp_source', 'Product') }}