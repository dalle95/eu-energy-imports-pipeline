select  year,
        month,
        product_group,
        sum(quantity_mwh) as total_qty_mwh,
        sum(value_euros) as total_value_eur,
        sum(value_euros) / nullif(sum(quantity_mwh), 0) as price_eur_per_mwh
from {{ ref('ftc_energy_imports') }}
group by    year, 
            month, 
            product_group