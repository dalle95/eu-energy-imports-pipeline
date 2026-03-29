select  year,
        month,
        product_group,
        sum(quantity_mwh) as qty,
        sum(value_euros) / nullif(sum(quantity_mwh), 0) as price
from {{ ref('ftc_energy_imports') }}
group by    year, 
            month, 
            product_group
order by    year,
            month, 
            product_group