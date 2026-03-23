with yearly as (
    select
        reporter_code,
        product,
        year,
        sum(quantity_mwh) as qty
    from {{ ref('ftc_energy_imports') }}
    group by 1,2,3
)

select
    *,
    qty - lag(qty) over (partition by reporter_code, product order by year) as yoy_diff,
    (qty / lag(qty) over (partition by reporter_code, product order by year)) - 1 as yoy_pct
from yearly