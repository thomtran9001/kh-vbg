{{ config(materialized='view', schema='query') }}

SELECT
  MD5(CONCAT(
        COALESCE((ticket_id)::text, ''),
        COALESCE((((json)::jsonb ->> 'id'))::text, ''),
        COALESCE((((json)::jsonb ->> 'type'))::text, ''),
        COALESCE((((json)::jsonb ->> 'value'))::text, '')
    )) ticket_form_id
  ,ticket_id
  ,last_update
  ,((json)::jsonb ->> 'id')  keys
  ,((json)::jsonb ->> 'name')  name
  ,((json)::jsonb ->> 'value') value
FROM (SELECT *
FROM (
    SELECT * ,
        ROW_NUMBER() OVER (PARTITION BY ticket_id ORDER BY last_update DESC) AS row_number
    FROM {{ ref('service_raw_service_ticket') }}
    ) t
WHERE t.row_number = 1)
CROSS JOIN LATERAL jsonb_array_elements(coalesce(form::jsonb, '[]'::jsonb)) AS json
WHERE (CASE WHEN ((json)::jsonb ->> 'value') = '' THEN NULL ELSE ((json)::jsonb ->> 'value') END) IS NOT NULL