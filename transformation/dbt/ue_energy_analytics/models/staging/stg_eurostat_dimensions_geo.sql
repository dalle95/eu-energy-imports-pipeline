{{ config(materialized='view') }}

with
dataset_eurostat_geo_dimensions as (
    select  *
    from {{ source('raw_energy', 'eurostat_dimensions_geo') }}
)

select *
from dataset_eurostat_geo_dimensions
