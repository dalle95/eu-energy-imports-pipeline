{% macro classify_product(product_code_column) %}

-- product_group
case
    when left({{ product_code_column }}, 4) = '2711' then 'gas'
    when left({{ product_code_column }}, 4) = '2709' then 'oil' -- crude (estendibile)
    when left({{ product_code_column }}, 4) = '2716' then 'electricity'
    else 'other'
end as product_group,

-- product_subgroup
case
    when {{ product_code_column }} = '271111' then 'lng'
    when {{ product_code_column }} = '271121' then 'pipeline'
    else 'other'
end as product_subgroup

{% endmacro %}