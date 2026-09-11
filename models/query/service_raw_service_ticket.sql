{{ config(materialized='view', schema='query') }}

SELECT
  CAST(id as int64) ticket_id,
 CAST(root_id as int64) root_id,
  CAST(block_id as int64) block_id,
  CAST(group_id as int64) group_id,
  name ticket_name,
  root_name,
  CAST(parent_id as int64) parent_ticket_id,
  CAST(service_id as int64) service_id,
  CAST(prev_id as int64) prev_id,
  form,
  assignees,
  username,
  content,
  status,
  CAST(TIMESTAMP_ADD(TIMESTAMP_SECONDS(cast(replace(since, '.0', '') as int64)), INTERVAL 7 HOUR) AS DATETIME) since,
  CAST(TIMESTAMP_ADD(TIMESTAMP_SECONDS(cast(replace(last_update, '.0', '') as int64)), INTERVAL 7 HOUR) AS DATETIME) last_update,
  CASE WHEN deadline is null then null else CAST(TIMESTAMP_ADD(TIMESTAMP_SECONDS(cast(replace(deadline, '.0', '') as int64)), INTERVAL 7 HOUR) AS DATETIME) end deadline,
  CASE
  WHEN ARRAY_TO_STRING(
    ARRAY(
      SELECT JSON_VALUE(item, '$.thau')
      FROM UNNEST(
        JSON_QUERY_ARRAY(SAFE_CAST(properties AS JSON), '$.categories')
      ) AS item
      WHERE JSON_VALUE(item, '$.thau') IS NOT NULL
    ),
    ','
  ) LIKE '%70%' THEN 'Thi công'

  WHEN ARRAY_TO_STRING(
    ARRAY(
      SELECT JSON_VALUE(item, '$.thau')
      FROM UNNEST(
        JSON_QUERY_ARRAY(SAFE_CAST(properties AS JSON), '$.categories')
      ) AS item
      WHERE JSON_VALUE(item, '$.thau') IS NOT NULL
    ),
    ','
  ) LIKE '%71%' THEN 'Tư vấn'

  ELSE NULL
END AS tag
FROM `kh-dia-chat-vietbac.airbyte_service.ticket`  t
order by since asc
