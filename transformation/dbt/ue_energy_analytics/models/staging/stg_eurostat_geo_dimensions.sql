{{ config(materialized='view') }}

with
dataset_eurostat_geo_dimensions as (
    select  *
    from {{ source('raw_energy', 'eurostat_geo_dimensions') }}
)

select *
from dataset_eurostat_geo_dimensions
