with
product as (
    select *
    from {{ ref("stg_eurostat_product_dimensions") }}
)

select *
from product