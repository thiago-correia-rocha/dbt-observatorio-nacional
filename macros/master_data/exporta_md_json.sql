{% macro exporta_md_json(table_name, export, filtro, layer) %}

    {% set bucket ='s3://observatorio-nacional-fs/' ~ layer  ~'/master_data/json/' ~ table_name.identifier ~ '/' ~ export ~ '/'  %}

    {% if export == 'territorios-geral' %}
       {% set  campos = ['cod_ibge','nivel','descricao','qtd_municipios'] %}
    {% endif %}

    {% if export == 'portal-geral' %}
       {% set  campos = [
            'id_conteudo',
            'tema',
            'indicador',
            'titulo_principal',
            'texto_principal',
            'titulo_ajuda',
            'texto_ajuda',
            'titulo_importancia',
            'texto_importancia',
            'fonte',
            'url_fonte',
            'url_wiki',
            'url_dashboard',
            'ano_referencia'
       ] %}
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