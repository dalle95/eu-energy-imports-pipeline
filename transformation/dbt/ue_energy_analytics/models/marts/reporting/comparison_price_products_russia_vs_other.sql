with 
ftc_energy_imports as (

    select  reporter_code,
            reporter_description,
            case 
                when partner_code != 'RU' then 'OT'
                else partner_code
            end as partner_code,
            case 
                when (partner_code != 'RU') then 'Other'
                else partner_description
            end as partner_description,
            product_code,
            product_group,
            product_subgroup,
            time_period,
            year,
            month,
            value_euros,
            native_quantity,
            native_unit,
            quantity_mwh,
            value_per_mwh
    from {{ ref('ftc_energy_imports') }}

),
avg_price_per_mwh_based_on_year as (

    select  reporter_code,
            reporter_description,
            partner_code,
            partner_description,
            product_group,
            year,
            sum(value_euros) / nullif(sum(quantity_mwh), 0) as avg_price_per_mwh
    from ftc_energy_imports
    group by    reporter_code,
                reporter_description,
                product_group,
                partner_code,
                partner_description,
                year
    order by    reporter_code,
                year

)

select *
from avg_price_per_mwh_based_on_year
