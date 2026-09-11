{{ config(materialized='table', schema='query') }}

SELECT
  MD5(CONCAT(
        COALESCE((task_id)::text, ''),
        COALESCE((((json)::jsonb ->> 'id'))::text, ''),
        COALESCE((((json)::jsonb ->> 'type'))::text, '')
    )) task_form_id
  ,task_id
  ,last_update
  ,((json)::jsonb ->> 'id')  keys
  ,((json)::jsonb ->> 'name')  name
  ,CASE WHEN ((json)::jsonb ->> 'value') = '' THEN NULL ELSE ((json)::jsonb ->> 'value') END value
  ,((json)::jsonb ->> 'type') type
FROM {{ ref('wework_raw_task') }}
CROSS JOIN LATERAL jsonb_array_elements(coalesce(form::jsonb, '[]'::jsonb)) AS json
