with total as (
    select  year,
            product,
            sum(quantity_mwh) as total_qty
    from {{ ref('ftc_energy_imports') }}
    group by year, product
),
russia as (
    select  year, 
            product,
            sum(quantity_mwh) as ru_qty
    from {{ ref('ftc_energy_imports') }}
    where partner_code = 'RU'
    group by year, product
)

select
    t.year,
    t.product,
    ru_qty / total_qty as dependency_ratio
from total t
join russia r using (year, product)
order by 1