with yearly as (
    select
        reporter_code,
        product,
        year,
        sum(value_euros) as value,
        sum(quantity_mwh) as qty
    from {{ ref('ftc_energy_imports') }}
    group by 1,2,3
)

select
    *,
    value / nullif(qty,0) as price
from yearly
order by 1,2,3,4