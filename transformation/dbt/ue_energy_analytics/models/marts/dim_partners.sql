with
partner as (
    select  distinct
            code,
            label,
            lang
    from {{ ref("stg_eurostat_dimensions_partner") }}
),

partner_fixes as (

    {{ partner_code_fixes() }}

),
partner_combined as (

    select *
    from partner

    union all

    select  pf.partner_code,
            pf.label,
            coalesce(ep.lang, 'en') as lang
    from partner_fixes pf
    left join partner ep on pf.partner_code = ep.code
    where ep.code is null

)

select  distinct
            code,
            label,
            lang
from partner_combined