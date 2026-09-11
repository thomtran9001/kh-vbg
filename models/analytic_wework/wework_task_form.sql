{{ config(materialized='incremental', schema='analytic_wework', unique_key='task_form_id') }}

SELECT
  * EXCEPT(last_update)
  ,MAX(last_update) OVER (PARTITION BY task_form_id) as last_update
FROM {{ ref('wework_raw_task_form') }}