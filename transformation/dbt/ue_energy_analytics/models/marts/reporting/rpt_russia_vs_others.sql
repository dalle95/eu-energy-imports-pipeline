with base as (

    select  year,
            month,
            case
                when partner_code = 'RU' then 'Russia'
                else 'Other'
            end as partner_group,
            sum(value_euros) as total_value_eur,
            sum(quantity_mwh) as total_qty,
            sum(value_euros) / nullif(sum(quantity_mwh), 0) as value_per_mwh
    from {{ ref('ftc_energy_imports') }}
    group by    year,
                month,
                case
                    when partner_code = 'RU' then 'Russia'
                    else 'Other'
                end

),
final as (

    select  year,
            month,
            partner_group,
            total_value_eur,
            total_qty,
            value_per_mwh,
            total_qty * 1.0 / nullif(sum(total_qty) over (partition by year, month), 0) as share_qty_pct,
            total_value_eur * 1.0 / nullif(sum(total_value_eur) over (partition by year, month), 0) as share_value_pct
    from base

)

select *
from final
order by year, month, partner_group