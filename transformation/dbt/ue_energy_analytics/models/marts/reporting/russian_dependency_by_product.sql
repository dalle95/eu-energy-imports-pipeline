with total as (
    select  year,
            product_code,
            product_group,
            product_subgroup,
            sum(quantity_mwh) as total_qty
    from {{ ref('ftc_energy_imports') }}
    group by    year, 
                product_code,
                product_group,
                product_subgroup,
),
russia as (
    select  year, 
            product_code,
            product_group,
            product_subgroup,
            sum(quantity_mwh) as ru_qty
    from {{ ref('ftc_energy_imports') }}
    where partner_code = 'RU'
    group by    year, 
                product_code,
                product_group,
                product_subgroup,
)

select
    t.year,
    t.product_code,
    t.product_group,
    t.product_subgroup,
    ru_qty / total_qty as dependency_ratio
from total t
join russia r using (year, product_code)
order by 1