{{ config(materialized='table', schema='analytic_service', unique_key='ticket_form_id') }}

SELECT DISTINCT ON (ticket_form_id) *
FROM {{ ref('service_raw_service_ticket_form') }}
ORDER BY ticket_form_id, last_update DESC
