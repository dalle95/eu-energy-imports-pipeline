with totals as (
    select
        reporter_code,
        product,
        year,
        sum(quantity_mwh) as total_qty
    from {{ ref('ftc_energy_imports') }}
    group by 1,2,3
)

select
    e.reporter_code,
    e.reporter_description,
    e.product,
    e.partner_code,
    e.partner_description,
    e.year,
    sum(e.quantity_mwh) / t.total_qty as market_share
from {{ ref('ftc_energy_imports') }} e
join totals t   on e.reporter_code = t.reporter_code
                and e.product = t.product
                and e.year = t.year
group by e.reporter_code, e.reporter_description, e.product, e.partner_code, e.partner_description, e.year, t.total_qty
order by e.reporter_code, e.product, e.partner_code, e.year, t.total_qty