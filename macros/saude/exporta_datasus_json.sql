{% macro exporta_datasus_json(table_name, export, filtro, layer) %}

    {% set bucket ='s3://observatorio-nacional-fs/' ~ layer  ~'/saude/datasus/json/' ~ table_name.identifier ~ '/' ~ export ~ '/'  %}

    {% if export == 'covid-cronologia' %}
       {% set  campos = ['data','titulo','url']
       %}
    {% endif %}


    {% if execute %}

        {% do run_query('SELECT 1') %}

        {% do adapter.delete_from_s3(bucket) %}

    {% endif %}


	unload (
        select
            {{ campos | join(',\n                ') }}
        from {{ table_name }}
        where {{ filtro }}
    )
    to '{{ bucket }}'
    with (
        format = 'json',
        compression = 'none'
    )

{% endmacro %}