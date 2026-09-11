{{ config(materialized='table', schema='analytic_wework', unique_key='id') }}

SELECT DISTINCT * FROM {{ ref('wework_raw_ke_hoach_thang') }}