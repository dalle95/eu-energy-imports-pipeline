{{ config(materialized='view') }}

with
dataset_comext_gas_imports_value as (
    select  reporter,
            partner,
            '2711' as product_code,
            TIME_PERIOD as time_period,
            cast(OBS_VALUE as decimal(38,2)) as value_euros
    from {{ source('raw_energy', 'comext_gas_imports_value') }}
)

select *
from dataset_comext_gas_imports_value