{{ config(materialized='view', schema='query') }}

SELECT
  MD5(CONCAT(
        IFNULL(cast(ticket_id AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$[0]') AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$[1]') AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$[2]') AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$[3]') AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$[4]') AS STRING), ''),
        IFNULL(cast(JSON_EXTRACT_SCALAR(json, '$[5]') AS STRING), '')
    )) id
  ,ticket_id root_id
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
  end khoi_luong
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[4]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[4]')
  end don_gia_vl
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[5]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[5]')
  end don_gia_nc
 ,case
    when JSON_EXTRACT_SCALAR(json, '$[6]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[6]')
  end don_gia_m
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[7]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[7]')
  end don_gia_cpc
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[8]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[8]')
  end he_so
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[9]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[9]')
  end thanh_tien_vl
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[10]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[10]')
  end thanh_tien_nc
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[11]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[11]')
  end thanh_tien_m
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[12]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[12]')
  end thanh_tien_cpc
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[13]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[13]')
  end he_so_pc_kv
  ,case
    when JSON_EXTRACT_SCALAR(json, '$[14]') = '' then NULL
    else JSON_EXTRACT_SCALAR(json, '$[14]')
  end thanh_tien_pc_kv
FROM (
  SELECT
    (json_extract_array(value)) AS json_array
    ,ticket_id
    ,last_update
  FROM (SELECT ticket_id, last_update, CAST(FROM_BASE64(value) AS STRING) value FROM {{ ref('service_raw_service_ticket_form') }} job_form 
      WHERE keys = 'service_cac_cong_tac_khai_dao' 
            -- and type = 'input-table' 
            AND NOT REGEXP_CONTAINS(cast(value as string), r'[áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴĐ]')
            AND cast(value as string) not like '%{}%'
            AND (value not like '%{}%') 
            AND (value not like '% %') 
            AND (value not like '%1.%'))
), UNNEST(json_array) AS json