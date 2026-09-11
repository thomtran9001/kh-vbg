{{ config(materialized='table', schema='query') }}

SELECT
  {{ appbi_safe_bigint("((json)::jsonb ->> 'id')") }}  id
  ,task_id
  ,last_update
  ,((json)::jsonb ->> 'name')  name
  ,{{ appbi_safe_bigint("((json)::jsonb ->> 'creator_id')") }}  creator_id
  ,{{ appbi_safe_bigint("((json)::jsonb ->> 'user_id')") }}  user_id
  ,{{ appbi_safe_bigint("((json)::jsonb ->> 'review')") }} review
  ,{{ appbi_safe_bigint("((json)::jsonb ->> 'status')") }}  status
  ,{{ appbi_epoch_hcm("((json)::jsonb ->> 'deadline')") }} deadline
FROM {{ ref('wework_raw_task') }}
CROSS JOIN LATERAL jsonb_array_elements(coalesce(cached_subtasks::jsonb, '[]'::jsonb)) AS json
