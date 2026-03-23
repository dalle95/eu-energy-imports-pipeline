with
partner as (
    select *
    from {{ ref("stg_eurostat_partner_dimensions") }}
)

select *
from partner