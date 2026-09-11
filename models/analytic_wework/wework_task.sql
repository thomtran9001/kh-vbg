{{ config(materialized='incremental', schema='analytic_wework', unique_key='task_id') }}

SELECT * EXCEPT(form, cached_subtasks) FROM {{ ref('wework_raw_task') }}