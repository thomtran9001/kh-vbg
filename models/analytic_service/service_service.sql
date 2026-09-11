{{ config(materialized='table', schema='analytic_service', unique_key='service_id') }}

SELECT * FROM {{ ref('service_raw_service') }}