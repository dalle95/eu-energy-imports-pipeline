with
partner as (
    select *
    from {{ ref("stg_eurostat_dimensions_partner") }}
)

select *
from partner