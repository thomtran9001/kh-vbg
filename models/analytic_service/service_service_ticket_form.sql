{{ config(materialized='table', schema='analytic_service', unique_key='ticket_form_id') }}

SELECT
  *
  ,MAX(last_update) OVER (PARTITION BY ticket_form_id) as last_update
FROM {{ ref('service_raw_service_ticket_form') }}