{{ config(materialized='view') }}

with
dataset_eurostat_unit_dimensions as (
    select  *
    from {{ source('raw_energy', 'eurostat_dimensions_unit') }}
)

select *
from dataset_eurostat_unit_dimensions
