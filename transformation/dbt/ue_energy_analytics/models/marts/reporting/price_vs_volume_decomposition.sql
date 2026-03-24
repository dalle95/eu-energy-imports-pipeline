with 
yearly as (
    select  reporter_code,
            product_code,
            product_group,
            product_subgroup,
            year,
            sum(value_euros) as value,
            sum(quantity_mwh) as qty
    from {{ ref('ftc_energy_imports') }}
    group by    reporter_code,
                product_code,
                product_group,
                product_subgroup,
                year
)

select  *,
        value / nullif(qty,0) as price
from yearly
order by 1,2,3,4