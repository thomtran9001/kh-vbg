{{ config(materialized='table', schema='analytic_wework', unique_key='project_id') }}

SELECT  distinct
  {{ appbi_safe_bigint('a.id') }} project_id
  ,a.name
  ,b.name as dept_name
  ,a.path
  ,{{ appbi_safe_bigint('a.status') }} status
  ,{{ appbi_safe_bigint('a.dept_id') }} dept_id
  ,a.content
  ,a.category
  ,{{ appbi_safe_bigint("((a.stats)::jsonb ->> 'active')") }} total_active
  ,{{ appbi_safe_bigint("((a.stats)::jsonb ->> 'complete')") }} total_complete
  ,{{ appbi_safe_bigint("((a.stats)::jsonb ->> 'overdue')") }} total_overdue
  ,CASE WHEN a.stime = '0' OR a.stime IS NULL THEN NULL ELSE {{ appbi_epoch_hcm('a.stime') }} END AS stime
  ,CASE WHEN a.etime = '0' OR a.etime IS NULL THEN NULL ELSE {{ appbi_epoch_hcm('a.etime') }} END AS etime
  ,{{ appbi_epoch_hcm('a.since') }} since
  ,{{ appbi_epoch_hcm('a.last_update') }} last_update
FROM {{ source('raw', 'project') }}  a
LEFT JOIN {{ source('raw', 'dept') }} b on a.dept_id = b.id 