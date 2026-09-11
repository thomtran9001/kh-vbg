{{ config(materialized='view', schema='query') }}

SELECT
  MD5(CONCAT(
        IFNULL(cast(task_id AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$.id') AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$.type') AS STRING), '')
    )) task_form_id
  ,task_id
  ,last_update
  ,JSON_EXTRACT_SCALAR(json, '$.id')  keys
  ,JSON_EXTRACT_SCALAR(json, '$.name')  name
  ,CASE WHEN JSON_EXTRACT_SCALAR(json, '$.value') = '' THEN NULL ELSE JSON_EXTRACT_SCALAR(json, '$.value') END value
  ,JSON_EXTRACT_SCALAR(json, '$.type') type
FROM {{ ref('wework_raw_task') }},
  UNNEST(JSON_EXTRACT_ARRAY(form)) AS json
