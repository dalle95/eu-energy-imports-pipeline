with
reporter as (
    select *
    from {{ ref("stg_eurostat_dimensions_geo") }}
)

select *
from reporter