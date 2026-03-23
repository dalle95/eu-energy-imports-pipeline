{% macro unit_conversions() %}

select *
from (
    values
        ('oil', '100kg', 'tonne', 0.1),
        ('oil', '100kg', 'mwh', 1.163),
        ('oil', 'tonne', 'tonne', 1.0),
        ('oil', 'tonne', 'mwh', 11.63),

        ('gas', 'm3', 'mwh', 0.01055),
        ('gas', 'kwh', 'mwh', 0.001),
        ('gas', 'mwh', 'mwh', 1.0),
        ('gas', '100kg', 'mwh', 1.335),

        ('electricity', 'kwh', 'mwh', 0.001),
        ('electricity', 'gwh', 'mwh', 1000.0),
        ('electricity', 'mwh', 'mwh', 1.0)
) as t (
    commodity,
    from_unit,
    to_unit,
    conversion_factor
)

{% endmacro %}