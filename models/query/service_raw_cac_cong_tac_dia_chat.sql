{{ config(materialized='view', schema='query') }}

SELECT
  MD5(CONCAT(
        COALESCE((ticket_id)::text, ''),
        COALESCE((((json)::jsonb ->> 0))::text, ''),
        COALESCE((((json)::jsonb ->> 1))::text, ''),
        COALESCE((((json)::jsonb ->> 2))::text, ''),
        COALESCE((((json)::jsonb ->> 3))::text, ''),
        COALESCE((((json)::jsonb ->> 4))::text, ''),
        COALESCE((((json)::jsonb ->> 5))::text, '')
    )) id
  ,ticket_id root_id
  ,last_update
  ,case
    when ((json)::jsonb ->> 0) = '' then NULL
    else ((json)::jsonb ->> 0)
  end ma_so
  ,case
    when ((json)::jsonb ->> 1) = '' then NULL
    else ((json)::jsonb ->> 1)
  end noi_dung
  ,case
    when ((json)::jsonb ->> 2) = '' then NULL
    else ((json)::jsonb ->> 2)
  end dvt
  ,case
    when ((json)::jsonb ->> 3) = '' then NULL
    else ((json)::jsonb ->> 3)
  end khoi_luong
  ,case
    when ((json)::jsonb ->> 4) = '' then NULL
    else ((json)::jsonb ->> 4)
  end don_gia_vl
  ,case
    when ((json)::jsonb ->> 5) = '' then NULL
    else ((json)::jsonb ->> 5)
  end don_gia_nc
 ,case
    when ((json)::jsonb ->> 6) = '' then NULL
    else ((json)::jsonb ->> 6)
  end don_gia_m
  ,case
    when ((json)::jsonb ->> 7) = '' then NULL
    else ((json)::jsonb ->> 7)
  end don_gia_cpc
  ,case
    when ((json)::jsonb ->> 8) = '' then NULL
    else ((json)::jsonb ->> 8)
  end he_so
  ,case
    when ((json)::jsonb ->> 9) = '' then NULL
    else ((json)::jsonb ->> 9)
  end thanh_tien_vl
  ,case
    when ((json)::jsonb ->> 10) = '' then NULL
    else ((json)::jsonb ->> 10)
  end thanh_tien_nc
  ,case
    when ((json)::jsonb ->> 11) = '' then NULL
    else ((json)::jsonb ->> 11)
  end thanh_tien_m
  ,case
    when ((json)::jsonb ->> 12) = '' then NULL
    else ((json)::jsonb ->> 12)
  end thanh_tien_cpc
  ,case
    when ((json)::jsonb ->> 13) = '' then NULL
    else ((json)::jsonb ->> 13)
  end he_so_pc_kv
  ,case
    when ((json)::jsonb ->> 14) = '' then NULL
    else ((json)::jsonb ->> 14)
  end thanh_tien_pc_kv
FROM (
  SELECT
    (value::jsonb) AS json_array
    ,ticket_id
    ,last_update
  FROM (SELECT ticket_id, last_update, convert_from(decode(value, 'base64'), 'UTF8') value FROM {{ ref('service_raw_service_ticket_form') }} job_form 
      WHERE keys = 'service_cac_cong_tac_dia_chat' 
            -- and type = 'input-table' 
            AND NOT ((value)::text ~ '[áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴĐ]'))
            AND (value)::text not like '%{}%'
            AND (value not like '%{}%') 
            AND (value not like '% %') 
            AND (value not like '%1.%'))
) s
CROSS JOIN LATERAL jsonb_array_elements(coalesce(json_array::jsonb, '[]'::jsonb)) AS json