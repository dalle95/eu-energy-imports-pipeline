select  year,
        month,
        product_subgroup,
        sum(quantity_mwh) as total_qty,
        sum(value_euros)/nullif(sum(quantity_mwh), 0) as price_eur_per_mwh
from {{ ref('ftc_energy_imports') }}
where product_group = 'gas'
group by    year, 
            month, 
            product_subgroup
order by    year,
            month, 
            product_subgroup