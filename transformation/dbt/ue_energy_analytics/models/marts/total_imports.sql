with
dataset as (

    select  reporter_code,
            product_code,
            product_group,
            product_subgroup,
            year,
            sum(value_euros) as total_value,
            sum(quantity_mwh) as total_quantity
    from {{ ref('ftc_energy_imports') }}
    group by    reporter_code,
                product_code,
                product_group,
                product_subgroup,
                year

)

select *
from dataset
