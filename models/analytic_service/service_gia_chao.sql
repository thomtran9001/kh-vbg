{{ config(materialized='table', schema='analytic_service', unique_key='id') }}

SELECT DISTINCT * FROM {{ ref('service_raw_gia_chao') }}