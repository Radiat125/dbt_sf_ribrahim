# dbt_sf_ribrahim
dbt snowflake medalion architecture

## Project Overview
This dbt project implements an ELT pipeline using the Medallion Architecture (Bronze → Silver → Gold), 
to convert an OLTP database into a dimensional star schema data warehouse.

## Architecture

### Bronze Layer (Raw Zone)
**Purpose:** Raw data replication from source systems
**Schema:** `bronze`
**Materialization:** Views

**Models:**
- `bronze_customers` - Raw customer data
- `bronze_suppliers` - Raw supplier data
- `bronze_products` - Raw product catalog
- `bronze_orders` - Raw order headers
- `bronze_order_items` - Raw order line items

**Transformations:**
- Column renaming for consistency
- Add load timestamps

### Silver Layer (Cleansed Zone)
**Purpose:** Cleansed, conformed, and validated data
**Schema:** `silver`
**Materialization:** Views

**Models:**
- `silver_customers` - Cleansed customer data
- `silver_suppliers` - Cleansed supplier data
- `silver_products` - Cleansed product data with validation
- `silver_orders` - Cleansed order data
- `silver_order_items` - Cleansed order items with calculated totals

**Transformations:**
- Trim whitespace
- Standardize nulls
- Validate business rules  by ensuring positive quantities and avoid non-negative prices.
- Calculated fields
- Data quality checks

### Gold Layer (Curated Zone)
**Purpose:** Business-level dimensional models optimized for analytics
**Schema:** `gold`
**Materialization:** Tables

**Dimension Models:**
- `dim_customer` - Customer dimension (Type 1 SCD)
- `dim_supplier` - Supplier dimension (Type 1 SCD)
- `dim_product` - Product dimension (Type 1 SCD)
- `dim_date` - Date dimension (conformed)

**Fact Models:**
- `fact_sales` - Sales fact table

**Transformations:**
- Generate surrogate keys
- Establish referential integrity
- Optimize for query performance

## Data Lineage
SOURCE (OLTP) -> BRONZE LAYER -> SILVER LAYER -> GOLD LAYER

**Owner:**
- Radiat Ibrahim