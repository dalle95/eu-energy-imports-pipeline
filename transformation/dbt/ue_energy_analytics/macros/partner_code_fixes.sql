{% macro partner_code_fixes() %}

select *
from (
    values
        ('GB', 'United Kingdom'),
        ('QZ', 'Extra-EU, not specified'),
        ('YU', 'Former Yugoslavia'),
        ('XS', 'Serbia'),
        ('XC', 'Ceuta'),
        ('QY', 'Extra-EU, not elsewhere specified'),
        ('QW', 'Extra-EU, unspecified partner'),
        ('QV', 'Extra-EU, confidential'),
        ('QU', 'Extra-EU, unknown'),
        ('QP', 'High seas / unspecified'),
        ('GR', 'Greece')

) as partner_fixes(partner_code, label)

{% endmacro %}