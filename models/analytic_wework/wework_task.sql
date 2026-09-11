{{ config(materialized='incremental', schema='analytic_wework', unique_key='task_id') }}

SELECT * FROM {{ ref('wework_raw_task') }}