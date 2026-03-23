with
energy_imports_value as (

    select
        reporter_code,
        partner_code,
        product_code,
        product,
        time_period,
        year,
        month,
        value_euros
    from {{ ref('int_comext_imports_value') }}

),
energy_imports_quantity as (

    select
        reporter_code,
        partner_code,
        product_code,
        product,
        time_period,
        year,
        month,
        native_quantity,
        native_unit,
        quantity_mwh
    from {{ ref('int_comext_imports_quantity') }}

),
reporter as (
    select *
    from {{ ref("dim_reporters") }}
),
partner as (
    select *
    from {{ ref("dim_partners") }}
),
energy_imports as (

    select
        eiv.reporter_code,
        r.label as reporter_description,
        eiv.partner_code,
        p.label as partner_description,
        eiv.product_code,
        eiv.product,
        eiv.time_period,
        eiv.year,
        eiv.month,
        eiv.value_euros,
        eiq.native_quantity,
        eiq.native_unit,
        eiq.quantity_mwh,
        (eiv.value_euros / NULLIF(eiq.quantity_mwh, 0)) as value_per_mwh
    from energy_imports_value eiv
    left join energy_imports_quantity eiq   on eiv.reporter_code = eiq.reporter_code
                                            and eiv.partner_code = eiq.partner_code
                                            and eiv.product_code = eiq.product_code
                                            and eiv.year = eiq.year
                                            and eiv.month = eiq.month
    left join reporter r on eiv.reporter_code = r.code
    left join partner p on eiv.partner_code = p.code

)

select *
from energy_imports