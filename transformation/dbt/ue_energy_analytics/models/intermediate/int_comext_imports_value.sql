with

comext_imports_value as (

    select
        reporter,
        partner,
        product_code,
        time_period,
        left(time_period, 4) as year,
        right(time_period, 2) as month,
        value_euros
        
    from {{ ref('stg_comext_oil_imports_value') }}

    union all

    select
        reporter,
        partner,
        product_code,
        time_period,
        left(time_period, 4) as year,
        right(time_period, 2) as month,
        value_euros
    from {{ ref('stg_comext_gas_imports_value') }}

),
dataset_with_product_detail as (

    select  
            civ.reporter as reporter_code,
            civ.partner as partner_code,
            civ.product_code,
            {{ classify_product('civ.product_code') }},
            civ.time_period,
            civ.year,
            civ.month,
            civ.value_euros            
    from comext_imports_value civ

)

select reporter_code,
       partner_code,
       product_code,
       product_group,
       product_subgroup,
       time_period,
       year,
       month,
       value_euros
from dataset_with_product_detail