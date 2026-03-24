with 
lng as (
    select  year, 
            product_code,
            product_group,
            product_subgroup,
            sum(quantity_mwh) as lng_qty
    from {{ ref('ftc_energy_imports') }}
    where product_group = 'gas'
    and product_subgroup = 'lng'
    group by    year, 
                product_code,
                product_group,
                product_subgroup
),
pipeline as (
    select  year, 
            product_code,
            product_group,
            product_subgroup,
            sum(quantity_mwh) as pipeline_qty
    from {{ ref('ftc_energy_imports') }}
    where product_group = 'gas'
    and product_subgroup = 'pipeline'
    group by    year, 
                product_code,
                product_group,
                product_subgroup
),
total_gas as (

    select  year,
            product_group,
            sum(quantity_mwh) as tot_qty
    from {{ ref('ftc_energy_imports') }}
    where product_group = 'gas'
    group by    year, 
                product_group
    
),
dipendency_type_gas as (
    
    select
            tot.year,
            tot.product_group,
            pipeline_qty,
            lng_qty,
            pipeline_qty/tot_qty as pipeline_dipendency,
            lng_qty/tot_qty as lng_dipendency
    from total_gas tot
    left join lng on tot.year = lng.year
    left join pipeline p on tot.year = p.year

)


select *
from dipendency_type_gas
order by year