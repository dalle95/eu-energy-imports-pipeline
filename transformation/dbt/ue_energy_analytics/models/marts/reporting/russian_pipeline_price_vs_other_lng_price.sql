with 
comparison as (

    select  year,
            sum(case
                when partner_code = 'RU'
                and product_group = 'gas'
                and product_subgroup = 'pipeline'
                then value_euros
                else 0
            end) as russian_pipeline_value_euros,
            sum(case
                when partner_code = 'RU'
                and product_group = 'gas'
                and product_subgroup = 'pipeline'
                then quantity_mwh
                else 0
            end) as russian_pipeline_qty_mwh,
            sum(case
                when partner_code != 'RU'
                and product_group = 'gas'
                and product_subgroup = 'lng'
                then value_euros
                else 0
            end) as other_lng_value_euros,
            sum(case
                when partner_code != 'RU'
                and product_group = 'gas'
                and product_subgroup = 'lng'
                then quantity_mwh
                else 0
            end) as other_lng_qty_mwh
    from {{ ref('ftc_energy_imports') }}
    group by year

)

select  year,
        russian_pipeline_qty_mwh,
        other_lng_qty_mwh,
        russian_pipeline_value_euros / nullif(russian_pipeline_qty_mwh, 0) as russian_pipeline_eur_per_mwh,
        other_lng_value_euros / nullif(other_lng_qty_mwh, 0) as other_lng_eur_per_mwh,
        (other_lng_value_euros / nullif(other_lng_qty_mwh, 0))
            - (russian_pipeline_value_euros / nullif(russian_pipeline_qty_mwh, 0)) as price_gap_eur_per_mwh
from comparison
order by year