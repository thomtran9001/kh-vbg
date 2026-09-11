{{ config(materialized='table', schema='query') }}

SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY task_id ORDER BY last_update DESC) AS row_number
    FROM (SELECT  
      {{ appbi_safe_bigint('id') }} task_id
      ,name
      ,metatype
      ,TRIM(REGEXP_REPLACE(REGEXP_REPLACE(content, '<[^>]+>', ''), '\s+', ' ')) AS content 
      ,{{ appbi_safe_bigint('parent_id') }} parent_id
      ,{{ appbi_safe_bigint('ancestor_id') }} ancestor_id
      ,{{ appbi_safe_bigint('project_id') }} project_id
      ,((ns)::jsonb ->> 'name') project_name
      ,{{ appbi_safe_bigint('status') }} status
      ,{{ appbi_safe_bigint('review') }} review
      ,{{ appbi_safe_bigint('urgent') }} urgent
      ,{{ appbi_safe_bigint('overdue') }} overdue
      ,{{ appbi_safe_bigint('starred') }} starred
      ,{{ appbi_safe_bigint('important') }} important
      ,{{ appbi_safe_bigint('started') }} started
      ,{{ appbi_safe_double('complete') }} complete
      ,{{ appbi_safe_bigint('creator_id') }} creator_id
      ,creator_username
      ,{{ appbi_safe_bigint('user_id') }} user_id
      ,username
      ,{{ appbi_safe_bigint('has_deadline') }} has_deadline
      ,{{ appbi_safe_bigint('milestone_id') }} milestone_id
      ,{{ appbi_safe_bigint('duration') }} duration
      ,(select string_agg(value, ',') from jsonb_array_elements_text(coalesce((tags)::jsonb, '[]'::jsonb)) as value) AS tags
      ,{{ appbi_safe_bigint("((stats)::jsonb ->> 'comments')") }} total_comments
      ,{{ appbi_safe_bigint("((stats)::jsonb ->> 'likes')") }} total_likes
      ,((result)::jsonb ->> 'content') AS result_content
      ,CASE WHEN stime = '0' OR start_time IS NULL THEN NULL ELSE {{ appbi_epoch_hcm('start_time') }} END AS start_time
      ,CASE WHEN stime = '0' OR stime IS NULL THEN NULL ELSE {{ appbi_epoch_hcm('stime') }} END AS stime
      ,CASE WHEN stime = '0' OR stime IS NULL THEN NULL ELSE {{ appbi_epoch_hcm('etime') }} END AS etime
      ,CASE WHEN deadline = '0' OR deadline IS NULL THEN NULL ELSE {{ appbi_epoch_hcm('deadline') }} END AS deadline
      ,CASE WHEN deadline = '0' OR completed_time IS NULL THEN NULL ELSE {{ appbi_epoch_hcm('completed_time') }} END AS completed_time
      ,{{ appbi_epoch_hcm('last_update') }} last_update
      ,{{ appbi_epoch_hcm('since') }} since
      ,{{ appbi_safe_bigint("((tasklist)::jsonb ->> 'id')") }} tasklist_id
      ,((tasklist)::jsonb ->> 'name') tasklist_name
      ,keywords
      ,(select string_agg(item ->> 'username', ', ') from jsonb_array_elements(coalesce((followers)::jsonb, '[]'::jsonb)) as item) AS followers
      ,(select string_agg(item ->> 'username', ', ') from jsonb_array_elements(coalesce((owners)::jsonb, '[]'::jsonb)) as item) AS owners, form, cached_subtasks
    FROM {{ source('raw', 'task') }} 
          
        ) a
) t
WHERE t.row_number = 1