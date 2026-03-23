{{ config(materialized='view') }}

with
dataset_comext_oil_imports_quantity as (
    select  reporter,
            partner,
            '2709' as product_code,
            TIME_PERIOD as time_period,
            cast(OBS_VALUE as decimal(38,2)) as quantity_100kg,
            '100kg' as quantity_unit
    from {{ source('raw_energy', 'comext_oil_imports_quantity') }}

)

select *
from dataset_comext_oil_imports_quantity