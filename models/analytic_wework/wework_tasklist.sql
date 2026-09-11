{{ config(materialized='table', schema='analytic_wework', unique_key='project_id') }}

SELECT  distinct
  CAST(JSON_VALUE(cached_tasklists, '$.id') AS INT64) tasklist_id,
  JSON_VALUE(cached_tasklists, '$.name') name
FROM `kh-dia-chat-vietbac.airbyte_wework.project` ,
UNNEST(JSON_QUERY_ARRAY(cached_tasklists)) AS cached_tasklists
