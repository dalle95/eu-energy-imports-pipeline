with 
ranked_suppliers as (

    select  year,
            partner_code,
            partner_description,
            sum(quantity_mwh) as total_qty,
            rank() over (partition by year order by sum(quantity_mwh) desc) as rank
    from {{ ref('ftc_energy_imports') }}
    group by    year,
                partner_code,
                partner_description
),
top_10_suppliers as (

    select  year,
            case when rank > 10 then 'OT' else partner_code end as partner_code,
            case when rank > 10 then 'Other' else partner_description end as partner_description,
            total_qty,
            case when rank > 10 then 1000 else rank end as rank
    from ranked_suppliers

),
grouped_suppliers as (
    
    select  year, 
            partner_code,
            partner_description,
            sum(total_qty) as total_qty,
            case when rank = 1000 then 'Other' else cast(rank as varchar) end as rank
    from top_10_suppliers
    group by year, partner_code, partner_description, rank
    order by year, cast(rank as int)

)

select *
from grouped_suppliers