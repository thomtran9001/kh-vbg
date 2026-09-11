{{ config(materialized='view', schema='query') }}

SELECT
  MD5(CONCAT(
        COALESCE((task_id)::text, ''),
        COALESCE((((json)::jsonb ->> 0))::text, ''),
        COALESCE((((json)::jsonb ->> 1))::text, ''),
        COALESCE((((json)::jsonb ->> 2))::text, '')
    )) id
  ,task_id
  ,last_update
  ,case
    when ((json)::jsonb ->> 0) = '' then NULL
    else ((json)::jsonb ->> 0)
  end phong_ban
  ,case
    when ((json)::jsonb ->> 1) = '' then NULL
    else ((json)::jsonb ->> 1)
  end khoi_luong
  ,case
    when ((json)::jsonb ->> 2) = '' then NULL
    else ((json)::jsonb ->> 2)
  end gia_tri

FROM (
  SELECT
    (value::jsonb) AS json_array
    ,task_id
    ,last_update
  FROM (SELECT task_id, last_update, convert_from(decode(value, 'base64'), 'UTF8') value FROM {{ ref('wework_raw_task_form') }} job_form 
      WHERE name = '[KHVT] Kế hoạch công việc Quý' 
            -- and type = 'input-table' 
            AND NOT ((value)::text ~ '[áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴĐ]')
            AND (value)::text not like '%{}%'
            AND (value::text not like '%{}%') 
            AND (value::text not like '% %') 
            AND (value::text not like '%1.%'))
) s
CROSS JOIN LATERAL jsonb_array_elements(coalesce(json_array::jsonb, '[]'::jsonb)) AS json