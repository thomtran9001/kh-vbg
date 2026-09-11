{{ config(materialized='view', schema='query') }}

SELECT
  MD5(CONCAT(
        IFNULL(cast(ticket_id AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$.id') AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$.type') AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$.value') AS STRING), '')
    )) ticket_form_id
  ,ticket_id
  ,last_update
  ,JSON_EXTRACT_SCALAR(json, '$.id')  keys
  ,JSON_EXTRACT_SCALAR(json, '$.name')  name
  ,JSON_EXTRACT_SCALAR(json, '$.value') value
FROM (SELECT * EXCEPT(row_number)
FROM (
    SELECT * ,
        ROW_NUMBER() OVER (PARTITION BY ticket_id ORDER BY last_update DESC) AS row_number
    FROM {{ ref('service_raw_service_ticket') }}
    ) t
WHERE t.row_number = 1),
  UNNEST(JSON_EXTRACT_ARRAY(form)) AS json
WHERE (CASE WHEN JSON_EXTRACT_SCALAR(json, '$.value') = '' THEN NULL ELSE JSON_EXTRACT_SCALAR(json, '$.value') END) IS NOT NULL