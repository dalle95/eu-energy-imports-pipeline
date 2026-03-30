# Metabase Dashboard Documentation

## Overview

This document describes how each chart in the Metabase dashboard was built, including:

* dataset logic (SQL)
* Metabase configuration
* filters and aggregation strategy

The goal is to make the dashboard fully **reproducible** without sharing the Metabase instance.

---

## Data Preparation

### `year_numeric` column

A derived column `year_numeric` (integer) was introduced to enable filtering directly in Metabase.

This allows splitting the analysis into:

* **Pre-sanctions:** `year_numeric <= 2021`
* **Post-sanctions:** `year_numeric >= 2022`

This approach avoids issues with string-based year fields and keeps filtering logic in the BI layer.

---

# 1. Evolution of EU Energy Imports

## Objective

Analyze how import volumes, values and prices evolved over time.

## Dataset rpt_imports_trend.sql

```sql
select  year,
        month,
        product_group,
        sum(quantity_mwh) as total_qty_mwh,
        sum(value_euros) as total_value_eur,
        sum(value_euros) / nullif(sum(quantity_mwh), 0) as price_eur_per_mwh
from {{ ref('ftc_energy_imports') }}
group by year, month, product_group
```

## Metabase Configuration

* Summarize:

  * Sum → total_qty_mwh
  * Sum → total_value_eur
  * Average → price_eur_per_mwh
* Group by:

  * Year

## Visualization

* Combo chart:

  * Bars → quantity
  * Line → value
  * Line → price

## Notes

The dataset is monthly, but aggregation is performed at yearly level in Metabase.

The price represents an **average of monthly weighted prices**, not a yearly weighted average.

---

# 2. Russia vs Other Suppliers

## Objective

Measure the dependency on Russian energy compared to other suppliers.

## Dataset rpt_russia_vs_others.sql

```sql
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
```

## Metabase Configuration

* Summarize:

  * Average → share_qty_pct
* Group by:

  * Year
  * Partner Group

## Visualization

* 100% stacked bar chart

## Notes

The chart shows:

> average monthly share of imports per year

This is not recalculated at yearly level, but averaged from monthly shares.

---

# 3. Supplier Mix

## Objective

Analyze how the supplier composition changed after sanctions.

## Dataset rpt_supplier_mix.sql

```sql
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
```

Top-N logic:

* rank suppliers by year
* keep top 10
* group others as "Other"

## Metabase Configuration

* Summarize:

  * Sum → total_qty
* Group by:

  * Year
  * Partner Description

## Visualization

* 100% stacked bar chart

## Notes

* Ranking is dynamic per year
* Suppliers may appear/disappear across years
* Values are absolute, but visualization is normalized

---

# 4. Price vs Volume

## Objective

Compare price evolution across energy types.

## Dataset rpt_price_vs_volume.sql

```sql
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
```

## Metabase Configuration

* Summarize:

  * Sum → qty
  * Average → price
* Group by:

  * Year
  * Product Group

## Visualization

* Line chart (gas vs oil)

## Notes

Price is:

> average of monthly weighted prices

---

# 5. LNG vs Pipeline

## Objective

Compare LNG and pipeline gas imports.

## Dataset rpt_gas_lng_vs_pipeline.sql

```sql
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
```

Filtered to gas only.

## Metabase Configuration

* Summarize:

  * Sum → total_qty
  * Average → price
* Group by:

  * Year
  * Product Subgroup

## Visualization

* 100% stacked bar chart

## Notes

* Shows structural shift in gas supply
* Same price aggregation caveat applies

---

## Final Considerations

* All business logic is implemented in SQL (dbt layer)
* Metabase is used only for aggregation and visualization
* Some metrics (price) are aggregated twice:

  * weighted at monthly level
  * averaged at yearly level

This should be considered when interpreting results.

---
