{{
    config(
        materialized='view',
        tags=['bronze', 'suppliers']
    )
}}

SELECT
    Id AS supplier_id,
    CompanyName AS company_name,
    ContactName AS contact_name,
    ContactTitle AS contact_title,
    City AS city,
    Country AS country,
    Phone AS phone,
    Fax AS fax,
    CURRENT_TIMESTAMP() AS bronze_loaded_at
FROM {{ source('oltp_source', 'Supplier') }}