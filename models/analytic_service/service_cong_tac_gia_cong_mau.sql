{{ config(materialized='table', schema='analytic_service', unique_key='id') }}

SELECT DISTINCT * FROM {{ ref('service_raw_cac_cong_tac_gia_cong_mau') }}