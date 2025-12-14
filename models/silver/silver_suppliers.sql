{{
    config(
        materialized='view',
        tags=['silver', 'suppliers']
    )
}}

-- Silver Layer: Cleansed and conformed supplier data

WITH bronze_suppliers AS (
    SELECT * FROM {{ ref('bronze_suppliers') }}
),

cleansed_supp AS (
    SELECT
        supplier_id,
        TRIM(company_name) AS company_name,
        NULLIF(TRIM(contact_name), '') AS contact_name,
        NULLIF(TRIM(contact_title), '') AS contact_title,
        NULLIF(TRIM(city), '') AS city,
        NULLIF(TRIM(country), '') AS country,
        NULLIF(TRIM(phone), '') AS phone,
        NULLIF(TRIM(fax), '') AS fax,
        bronze_loaded_at,
        CURRENT_TIMESTAMP() AS silver_loaded_at
    FROM bronze_suppliers
)

SELECT * FROM cleansed_supp