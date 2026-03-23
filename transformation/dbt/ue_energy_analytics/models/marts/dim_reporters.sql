with
reporter as (
    select *
    from {{ ref("stg_eurostat_geo_dimensions") }}
)

select *
from reporter