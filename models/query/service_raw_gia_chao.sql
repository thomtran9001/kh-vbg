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
  end khoan_muc_chi_phi
  ,case
    when ((json)::jsonb ->> 1) = '' then NULL
    else ((json)::jsonb ->> 1)
  end cach_tinh
  ,case
    when ((json)::jsonb ->> 2) = '' then NULL
    else ((json)::jsonb ->> 2)
  end ky_hieu
  ,case
    when ((json)::jsonb ->> 3) = '' then NULL
    else ((json)::jsonb ->> 3)
  end tong_gia_tri
FROM (
  SELECT
    (value::jsonb) AS json_array
    ,ticket_id
    ,last_update
  FROM (SELECT ticket_id, last_update, convert_from(decode(value, 'base64'), 'UTF8') value FROM {{ ref('service_raw_service_ticket_form') }} job_form 
      WHERE keys = 'service_bang_tong_hop_gia_chao' 
            -- and type = 'input-table' 
            AND NOT ((value)::text ~ '[áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴĐ]'))
            AND (value)::text not like '%{}%'
            AND (value not like '%{}%') 
            AND (value not like '% %') 
            AND (value not like '%1.%'))
) s
CROSS JOIN LATERAL jsonb_array_elements(coalesce(json_array::jsonb, '[]'::jsonb)) AS json