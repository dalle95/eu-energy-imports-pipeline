{{ config(materialized='view') }}

with
dataset_eurostat_partner_dimensions as (
    select  *
    from {{ source('raw_energy', 'eurostat_dimensions_partner') }}
)

select *
from dataset_eurostat_partner_dimensions
