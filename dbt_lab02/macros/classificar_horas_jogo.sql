{% macro classificar_horas_jogo(coluna) %}
    case
        when {{ coluna }} < 2  then '< 2h'
        when {{ coluna }} < 4  then '2-4h'
        when {{ coluna }} < 6  then '4-6h'
        when {{ coluna }} < 8  then '6-8h'
        else '> 8h'
    end
{% endmacro %}