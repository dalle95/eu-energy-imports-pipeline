with 
gas_dependency as (

    select  year,
            sum(case when product_group = 'gas' then quantity_mwh else 0 end) as total_gas_qty,
            sum(case when product_group = 'gas' and product_subgroup = 'pipeline' then quantity_mwh else 0 end) as pipeline_qty,
            sum(case when product_group = 'gas' and product_subgroup = 'lng' then quantity_mwh else 0 end) as lng_qty
    from {{ ref('ftc_energy_imports') }}
    group by year

)

select  year,
        total_gas_qty,
        pipeline_qty,
        lng_qty,
        pipeline_qty / nullif(total_gas_qty, 0) as pipeline_dependency,
        lng_qty / nullif(total_gas_qty, 0) as lng_dependency
from gas_dependency
order by year