{{
    config(
        materialized='view',
        tags=['bronze', 'customers']
    )
}}

-- Bronze Layer: Raw replication from source
-- No tangible transformations, just column renaming for consistency

SELECT
    Id AS customer_id,
    FirstName AS first_name,
    LastName AS last_name,
    City AS city,
    Country AS country,
    Phone AS phone,
    CURRENT_TIMESTAMP() AS bronze_loaded_at
FROM {{ source('oltp_source', 'Customer') }}