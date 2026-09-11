{{ config(materialized='table', schema='query') }}

SELECT
  MD5(CONCAT(
        COALESCE((task_id)::text, ''),
        COALESCE((((json)::jsonb ->> 0))::text, ''),
        COALESCE((((json)::jsonb ->> 1))::text, ''),
        COALESCE((((json)::jsonb ->> 2))::text, ''),
        COALESCE((((json)::jsonb ->> 3))::text, ''),
        COALESCE((((json)::jsonb ->> 4))::text, ''),
        COALESCE((((json)::jsonb ->> 5))::text, '')
    )) id
  ,task_id
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
  end ket_qua
  ,case
    when ((json)::jsonb ->> 4) = '' then NULL
    else ((json)::jsonb ->> 4)
  end don_gia
  ,case
    when ((json)::jsonb ->> 5) = '' then NULL
    else ((json)::jsonb ->> 5)
  end thanh_tien

FROM (
  SELECT
    (value::jsonb) AS json_array
    ,task_id
    ,last_update
  FROM (SELECT task_id, last_update, convert_from(decode(value, 'base64'), 'UTF8') value FROM {{ ref('wework_raw_task_form') }} job_form 
      WHERE name = 'Công tác địa chất' 
            -- and type = 'input-table' 
            AND NOT ((value)::text ~ '[áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴĐ]')
            AND (value)::text not like '%{}%'
            AND (value::text not like '%{}%') 
            AND (value::text not like '% %') 
            AND (value::text not like '%1.%'))
) s
CROSS JOIN LATERAL jsonb_array_elements(coalesce(json_array::jsonb, '[]'::jsonb)) AS json