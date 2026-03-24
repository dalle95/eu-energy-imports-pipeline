with 
yearly as (
    select  reporter_code,
            product_code,
            product_group,
            product_subgroup,
            year,
            sum(quantity_mwh) as qty
    from {{ ref('ftc_energy_imports') }}
    group by    year,
                reporter_code,
                product_code,
                product_group,
                product_subgroup
)

select  *,
        qty - lag(qty) over (partition by reporter_code, reporter_code order by year) as yoy_diff,
        (qty / lag(qty) over (partition by reporter_code, reporter_code order by year)) - 1 as yoy_pct
from yearly