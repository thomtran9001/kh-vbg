{{ config(materialized='incremental', schema='analytic_wework', unique_key='id') }}

SELECT DISTINCT ON (id) *
FROM {{ ref('wework_raw_cached_subtasks') }}
ORDER BY id, last_update DESC
