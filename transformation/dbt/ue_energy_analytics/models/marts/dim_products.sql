with
product as (
    select *
    from {{ ref("stg_eurostat_dimensions_product") }}
)

select *
from product