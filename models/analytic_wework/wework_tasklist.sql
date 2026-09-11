{{ config(materialized='table', schema='analytic_wework', unique_key='project_id') }}

SELECT  distinct
  {{ appbi_safe_bigint("((cached_tasklists)::jsonb ->> 'id')") }} tasklist_id,
  ((cached_tasklists)::jsonb ->> 'name') name
FROM {{ source('raw', 'project') }}
CROSS JOIN LATERAL jsonb_array_elements(coalesce(cached_tasklists::jsonb, '[]'::jsonb)) AS cached_tasklists
