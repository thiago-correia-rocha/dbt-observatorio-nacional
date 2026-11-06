{% macro exporta_datasus_json(table_name, export, filtro, layer) %}

    {% set bucket ='s3://observatorio-nacional-fs/' ~ layer  ~'/saude/datasus/json/' ~ table_name.identifier ~ '/' ~ export ~ '/'  %}

    {% if export == 'covid-cronologia' %}
       {% set  campos = ['data','titulo','url'] %}
    {% endif %}

    {% if export == 'covid-caso' %}
       {% set  campos = ['cod_ibge','nivel','url','vacinados','vacinados_2_dose','vacinados_dose_unica','imunizados','vacinados_3_dose','vacinas_aplicadas','recuperados','testes'] %}
    {% endif %}

    {% if export == 'covid-caso-tl' %}
       {% set  campos = ['cod_ibge','nivel','data','casosacumulado','casosacumulado_perct','obitosacumulado ','obitosacumulado_perct','casosnovos','obitosNovos','Recuperadosnovos','emAcompanhamentoNovos'] %}
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