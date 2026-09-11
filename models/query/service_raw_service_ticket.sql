{{ config(materialized='view', schema='query') }}

SELECT
  {{ appbi_safe_bigint('id') }} ticket_id,
 {{ appbi_safe_bigint('root_id') }} root_id,
  {{ appbi_safe_bigint('block_id') }} block_id,
  {{ appbi_safe_bigint('group_id') }} group_id,
  name ticket_name,
  root_name,
  {{ appbi_safe_bigint('parent_id') }} parent_ticket_id,
  {{ appbi_safe_bigint('service_id') }} service_id,
  {{ appbi_safe_bigint('prev_id') }} prev_id,
  form,
  assignees,
  username,
  content,
  status,
  {{ appbi_epoch_hcm('since') }} since,
  {{ appbi_epoch_hcm('last_update') }} last_update,
  CASE WHEN deadline is null then null else {{ appbi_epoch_hcm('deadline') }} end deadline,
  CASE
    WHEN (select string_agg(cat ->> 'thau', ',') from jsonb_array_elements(coalesce((properties::jsonb -> 'categories'), '[]'::jsonb)) as cat) LIKE '%70%' THEN 'Thi công'
    WHEN (select string_agg(cat ->> 'thau', ',') from jsonb_array_elements(coalesce((properties::jsonb -> 'categories'), '[]'::jsonb)) as cat) LIKE '%71%' THEN 'Tư vấn'
    ELSE NULL
  END AS tag
FROM {{ source('raw', 'ticket') }}  t
order by since asc
