{{ config(materialized='incremental', schema='analytic_wework', unique_key='task_form_id') }}

SELECT DISTINCT ON (task_form_id) *
FROM {{ ref('wework_raw_task_form') }}
ORDER BY task_form_id, last_update DESC
