{{ config(materialized='incremental', schema='analytic_wework', unique_key='id') }}

SELECT
  * EXCEPT(last_update)
  ,MAX(last_update) OVER (PARTITION BY id) as last_update
FROM {{ ref('wework_raw_cached_subtasks') }}