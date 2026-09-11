{{ config(materialized='table', schema='analytic_service', unique_key='ticket_id') }}

SELECT DISTINCT * FROM {{ ref('service_raw_service_ticket_assignees') }}
  