{{ config(materialized='table', schema='query') }}

SELECT
 ticket_id,
{{ appbi_epoch_hcm("((item)::jsonb ->> 'deadline')") }} AS deadline,
{{ appbi_epoch_hcm("((item)::jsonb ->> 'last_update')") }} AS last_update,
  ((item)::jsonb ->> 'note') AS note,
  {{ appbi_safe_bigint("((item)::jsonb ->> 'signed')") }} AS signed,
  {{ appbi_epoch_hcm("((item)::jsonb ->> 'since')") }} AS since,
  {{ appbi_epoch_hcm("((item)::jsonb ->> 'started_at')") }} AS started_at,
  ((item)::jsonb ->> 'username') AS username
FROM {{ ref('service_raw_service_ticket') }}  t
CROSS JOIN LATERAL jsonb_array_elements(coalesce(assignees::jsonb, '[]'::jsonb)) AS item