{{ config(materialized='table', schema='analytic_wework', unique_key='project_id') }}

SELECT  distinct
  cast(replace(id, '.0', '') as int64) dept_id
  ,name
  ,path
  ,alias
  ,CAST(TIMESTAMP_ADD(TIMESTAMP_SECONDS(cast(replace(since, '.0', '') as int64)), INTERVAL 7 HOUR) AS DATETIME) since
FROM `kh-dia-chat-vietbac.airbyte_wework.dept` 