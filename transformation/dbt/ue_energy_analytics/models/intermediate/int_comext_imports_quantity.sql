with
comext_imports_quantity as (

    select
        reporter,
        partner,
        product_code,
        time_period,
        left(time_period, 4) as year,
        right(time_period, 2) as month,
        quantity_100kg,
        quantity_unit
    from {{ ref('stg_comext_oil_imports_quantity') }}

    union all

    select
        reporter,
        partner,
        product_code,
        time_period,
        left(time_period, 4) as year,
        right(time_period, 2) as month,
        quantity_100kg,
        quantity_unit
    from {{ ref('stg_comext_gas_imports_quantity') }}

),
unit_conversions as (

    {{ unit_conversions() }}

),
dataset_with_product_detail as (

    select
            ciq.reporter as reporter_code,
            ciq.partner as partner_code,
            ciq.product_code,
            {{ classify_product('ciq.product_code') }},
            ciq.time_period,
            ciq.year,
            ciq.month,
            ciq.quantity_100kg as native_quantity,
            ciq.quantity_unit as native_unit
           
    from comext_imports_quantity ciq
    

),
dataset_with_conversion as (

    select  *
            ,dpd.native_quantity * uc.conversion_factor as quantity_mwh
    from dataset_with_product_detail dpd
    left join unit_conversions uc   on dpd.product_group = uc.commodity
                                    and dpd.native_unit = uc.from_unit
                                    and uc.to_unit = 'mwh'

)

select  reporter_code,
        partner_code,
        product_code,
        product_group,
        product_subgroup,
        time_period,
        year,
        month,
        native_quantity,
        native_unit,
        quantity_mwh
from dataset_with_conversion
