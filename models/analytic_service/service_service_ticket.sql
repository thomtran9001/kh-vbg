{{ config(materialized='table', schema='analytic_service', unique_key='ticket_id') }}

SELECT DISTINCT *
FROM (
    SELECT * ,
        ROW_NUMBER() OVER (PARTITION BY ticket_id ORDER BY last_update DESC) AS row_number
    FROM {{ ref('service_raw_service_ticket') }}
    ) t
WHERE t.row_number = 1