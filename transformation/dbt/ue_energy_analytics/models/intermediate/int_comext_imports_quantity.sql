with
comext_imports_quantity as (

    select
        reporter,
        partner,
        product_code,
        'oil' as product,
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
        'gas' as product,
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
final as (

    select
            ciq.reporter as reporter_code,
            ciq.partner as partner_code,
            ciq.product_code,
            ciq.product,
            ciq.time_period,
            ciq.year,
            ciq.month,
            ciq.quantity_100kg as native_quantity,
            ciq.quantity_unit as native_unit,
            ciq.quantity_100kg * uc.conversion_factor as quantity_mwh
    from comext_imports_quantity ciq
    left join unit_conversions uc   on ciq.product = uc.commodity
                                    and ciq.quantity_unit = uc.from_unit
                                    and uc.to_unit = 'mwh'

)

select *
from final