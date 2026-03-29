with 
totals as (

    select  reporter_code,
            product_code,
            product_group,
            product_subgroup,
            year,
            sum(quantity_mwh) as total_qty
    from {{ ref('ftc_energy_imports') }}
    group by    reporter_code,
                product_code,
                product_group,
                product_subgroup,
                year
)

select  e.reporter_code,
        e.reporter_description,
        e.product_code,
        e.product_group,
        e.product_subgroup,
        e.partner_code,
        e.partner_description,
        e.year,
        sum(e.quantity_mwh) / t.total_qty as market_share
from {{ ref('ftc_energy_imports') }} e
join totals t   on e.reporter_code = t.reporter_code
                and e.product_code = t.product_code
                and e.year = t.year
group by e.reporter_code, e.reporter_description, e.product_code, e.product_group, e.product_subgroup, e.partner_code, e.partner_description, e.year, t.total_qty
order by e.reporter_code, e.product_code, e.partner_code, e.year, t.total_qty