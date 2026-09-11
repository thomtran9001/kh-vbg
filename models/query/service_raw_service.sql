{{ config(materialized='table', schema='query') }}

SELECT DISTINCT
  {{ appbi_safe_bigint('id') }} service_id,
  name service_name
FROM {{ source('raw_service', 'service') }} 
