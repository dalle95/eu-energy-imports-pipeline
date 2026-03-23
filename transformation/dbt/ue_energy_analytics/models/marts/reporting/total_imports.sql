with
dataset as (

    select
        reporter_code,
        product,
        year,
        sum(value_euros) as total_value,
        sum(quantity_mwh) as total_quantity
    from {{ ref('ftc_energy_imports') }}
    group by 1,2,3

)

select *
from dataset
