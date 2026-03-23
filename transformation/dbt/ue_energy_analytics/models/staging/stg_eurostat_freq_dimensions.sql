{{ config(materialized='view') }}

with
dataset_eurostat_freq_dimensions as (
    select  *
    from {{ source('raw_energy', 'eurostat_freq_dimensions') }}
)

select *
from dataset_eurostat_freq_dimensions
