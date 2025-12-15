{{
    config(
        materialized='table',
        unique_key='supplier_key',
        tags=['gold', 'dimension', 'supplier']
    )
}}

-- Gold Layer: Supplier Dimension (Type 1 SCD)

WITH silver_suppliers AS (
    SELECT * FROM {{ ref('silver_suppliers') }}
),

dimension_supp AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['supplier_id']) }} AS supplier_key,
        supplier_id,
        company_name,
        contact_name,
        contact_title,
        city,
        country,
        phone,
        fax,
        silver_loaded_at AS effective_date,
        CURRENT_TIMESTAMP() AS gold_loaded_at
    FROM silver_suppliers
)

SELECT * FROM dimension_supp