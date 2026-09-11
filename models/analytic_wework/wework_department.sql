{{ config(materialized='table', schema='analytic_wework', unique_key='project_id') }}

SELECT  distinct
  {{ appbi_safe_bigint('id') }} dept_id
  ,name
  ,path
  ,alias
  ,{{ appbi_epoch_hcm('since') }} since
FROM {{ source('raw', 'dept') }} 