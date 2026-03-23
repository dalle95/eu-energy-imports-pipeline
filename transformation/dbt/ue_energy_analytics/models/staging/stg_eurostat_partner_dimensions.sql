{{ config(materialized='view') }}

with
dataset_eurostat_partner_dimensions as (
    select  *
    from {{ source('raw_energy', 'eurostat_partner_dimensions') }}
)

select *
from dataset_eurostat_partner_dimensions
