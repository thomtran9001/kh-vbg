{{ config(materialized='table', schema='analytic_wework', unique_key='id') }}

SELECT DISTINCT * FROM {{ ref('wework_raw_cong_tac_trac_dia') }}