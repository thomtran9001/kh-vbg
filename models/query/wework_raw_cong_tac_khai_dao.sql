{{ config(materialized='view', schema='query') }}

SELECT
  MD5(CONCAT(
        IFNULL(cast(task_id AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$[0]') AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$[1]') AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$[2]') AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$[3]') AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$[4]') AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$[5]') AS STRING), '')
    )) id
  ,task_id
  ,last_update
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[0]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[0]')
  end ma_so
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[1]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[1]')
  end noi_dung
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[2]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[2]')
  end dvt
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[3]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[3]')
  end ket_qua
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[4]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[4]')
  end don_gia
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[5]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[5]')
  end thanh_tien

FROM (
  SELECT
    (json_extract_array(value)) AS json_array
    ,task_id
    ,last_update
  FROM (SELECT task_id, last_update, CAST(FROM_BASE64(value) AS STRING) value FROM {{ ref('wework_raw_task_form') }} job_form 
      WHERE name = 'Công tác khai đào' 
            -- and type = 'input-table' 
            AND NOT REGEXP_CONTAINS(cast(value as string), r'[áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴĐ]')
            AND cast(value as string) not like '%{}%'
            AND (value not like '%{}%') 
            AND (value not like '% %') 
            AND (value not like '%1.%'))
), UNNEST(json_array) AS json