{% macro appbi_safe_bigint(expr) -%}
    nullif(regexp_replace(({{ expr }})::text, '\.0$', ''), '')::bigint
{%- endmacro %}

{% macro appbi_safe_double(expr) -%}
    nullif(regexp_replace(({{ expr }})::text, '\.0$', ''), '')::double precision
{%- endmacro %}

{% macro appbi_epoch_hcm(expr) -%}
    case
        when ({{ expr }}) is null or ({{ expr }})::text in ('', '0') then null
        else (to_timestamp(nullif(regexp_replace(({{ expr }})::text, '\.0$', ''), '')::double precision) + interval '7 hours')::timestamp
    end
{%- endmacro %}
