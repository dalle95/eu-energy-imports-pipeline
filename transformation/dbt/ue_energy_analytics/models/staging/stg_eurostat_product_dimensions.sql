{{ config(materialized='view') }}

with
dataset_eurostat_siec_dimensions as (
    select  *
    from {{ source('raw_energy', 'eurostat_siec_dimensions') }}
)

select *
from dataset_eurostat_siec_dimensions
