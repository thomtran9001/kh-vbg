{{ config(materialized='view', schema='query') }}

SELECT * EXCEPT(row_number)
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY task_id ORDER BY last_update DESC) AS row_number
    FROM (SELECT  
      cast(replace(id, '.0', '') as int64) task_id
      ,name
      ,metatype
      ,TRIM(REGEXP_REPLACE(REGEXP_REPLACE(content, r'<[^>]+>', ''), r'\s+', ' ')) AS content 
      ,CAST(parent_id as INT64) parent_id
      ,CAST(ancestor_id as INT64) ancestor_id
      ,CAST(project_id as INT64) project_id
      ,JSON_EXTRACT_SCALAR(ns, '$.name') project_name
      ,CAST(status as INT64) status
      ,CAST(review as INT64) review
      ,CAST(urgent as INT64) urgent
      ,CAST(overdue as INT64) overdue
      ,CAST(starred as INT64) starred
      ,CAST(important as INT64) important
      ,CAST(started as INT64) started
      ,CAST(complete as FLOAT64) complete
      ,CAST(creator_id as INT64) creator_id
      ,creator_username
      ,CAST(user_id as INT64) user_id
      ,username
      ,CAST(has_deadline as INT64) has_deadline
      ,CAST(milestone_id as INT64) milestone_id
      ,CAST(duration as INT64) duration
      ,ARRAY_TO_STRING(JSON_VALUE_ARRAY(tags), ',') AS tags
      ,cast(JSON_EXTRACT_SCALAR(stats, '$.comments') as int64) total_comments
      ,cast(JSON_EXTRACT_SCALAR(stats, '$.likes') as int64) total_likes
      ,JSON_VALUE(result, '$.content') AS result_content
      ,CASE WHEN stime = '0' OR start_time IS NULL THEN NULL ELSE CAST(TIMESTAMP_ADD(TIMESTAMP_SECONDS(CAST(REPLACE(start_time, '.0', '') AS INT64)), INTERVAL 7 HOUR) AS DATETIME) END AS start_time
      ,CASE WHEN stime = '0' OR stime IS NULL THEN NULL ELSE CAST(TIMESTAMP_ADD(TIMESTAMP_SECONDS(CAST(REPLACE(stime, '.0', '') AS INT64)), INTERVAL 7 HOUR) AS DATETIME) END AS stime
      ,CASE WHEN stime = '0' OR stime IS NULL THEN NULL ELSE CAST(TIMESTAMP_ADD(TIMESTAMP_SECONDS(CAST(REPLACE(etime, '.0', '') AS INT64)), INTERVAL 7 HOUR) AS DATETIME) END AS etime
      ,CASE WHEN deadline = '0' OR deadline IS NULL THEN NULL ELSE CAST(TIMESTAMP_ADD(TIMESTAMP_SECONDS(CAST(REPLACE(deadline, '.0', '') AS INT64)), INTERVAL 7 HOUR) AS DATETIME) END AS deadline
      ,CASE WHEN deadline = '0' OR completed_time IS NULL THEN NULL ELSE CAST(TIMESTAMP_ADD(TIMESTAMP_SECONDS(CAST(REPLACE(completed_time, '.0', '') AS INT64)), INTERVAL 7 HOUR) AS DATETIME) END AS completed_time
      ,CAST(TIMESTAMP_ADD(TIMESTAMP_SECONDS(cast(replace(last_update, '.0', '') as int64)), INTERVAL 7 HOUR) AS DATETIME) last_update
      ,CAST(TIMESTAMP_ADD(TIMESTAMP_SECONDS(cast(replace(since, '.0', '') as int64)), INTERVAL 7 HOUR) AS DATETIME) since
      ,cast(JSON_EXTRACT_SCALAR(tasklist, '$.id') as int64) tasklist_id
      ,JSON_EXTRACT_SCALAR(tasklist, '$.name') tasklist_name
      ,keywords
      ,ARRAY_TO_STRING(
        ARRAY(
          SELECT JSON_VALUE(item, '$.username')
          FROM UNNEST(JSON_QUERY_ARRAY(followers)) AS item
        ),
        ', '
      ) AS followers
      ,ARRAY_TO_STRING(
        ARRAY(
          SELECT JSON_VALUE(item, '$.username')
          FROM UNNEST(JSON_QUERY_ARRAY(owners)) AS item
        ),
        ', '
      ) AS owners, form, cached_subtasks
    FROM `kh-dia-chat-vietbac.airbyte_wework.task` 
          WHERE TIMESTAMP_TRUNC(_airbyte_extracted_at, DAY) BETWEEN TIMESTAMP_TRUNC(TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 DAY), DAY) AND TIMESTAMP_TRUNC(CURRENT_TIMESTAMP, DAY)
        ) a
) t
WHERE t.row_number = 1