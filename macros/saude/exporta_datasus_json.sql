{% macro exporta_datasus_json(table_name, export, filtro, layer) %}

    {% set bucket ='s3://observatorio-nacional-fs/' ~ layer  ~'/saude/datasus/json/' ~ table_name.identifier ~ '/' ~ export ~ '/'  %}

    {% if export == 'populacao-religiao' %}
       {% set  campos = [
                  'cod_ibge',
                  'nivel',
                  'descricao',
                  'faixa_etaria',
                  'rel_total',
                  'rel_totalcatolica_perct',
                  'rel_totalevangelica_perct',
                  'rel_total_cristao_perct',
                  'rel_totalespirita_perct',
                  'rel_totalumbanda_perct',
                  'rel_totaltradind_perct',
                  'rel_totaloutras_perct',
                  'rel_totalateu_perct',
                  'rel_totalnaosabe_perct',
                  'rel_totalsd_perct'
                  ]
       %}
    {% endif %}

    {% if export == 'populacao-povos-originarios' %}
       {% set  campos = [
                  'cod_ibge',
                  'nivel',
                  'descricao',
                  'faixa_etaria',
	              'ind_total',
	              'ind_em_terras_total',
                  'ind_em_terras_total_perct',
                  'ind_fora_terras_total',
                  'ind_fora_terras_total_perct',
                  'ind_homens',
                  'ind_homens_perct',
                  'ind_em_terras_homens',
                  'ind_fora_terras_homens',
                  'ind_mulheres',
                  'ind_mulheres_perct',
                  'ind_em_terras_mulheres',
                  'ind_fora_terras_mulheres',
                  'quilo_total',
                  'quilo_em_terras',
                  'quilo_em_terras_perct',
                  'quilo_fora_terras',
                  'quilo_fora_terras_perct'
                  ]
       %}
    {% endif %}

    {% if export == 'populacao-cor' %}
       {% set  campos = [
                  'cod_ibge',
                  'nivel',
                  'descricao',
                  'faixa_etaria',
                  'branca_perct',
                  'preta_perct',
                  'amarela_perct',
                  'parda_perct',
                  'indigena_perct'
                  ]
       %}
    {% endif %}

    {% if export == 'populacao-geral' %}
       {% set  campos = [
                  'cod_ibge',
                  'nivel',
                  'descricao',
                  'faixa_etaria',
                  'pop_total',
                  'mulheres_pop',
                  'mulheres_pop_perct',
                  'homens_pop',
                  'homens_pop_perct',
                  'pop_ranking',
                  'pop_per_dom',
                  'pop_fav',
                  'pop_fav_perct',
                  'mulheres_pop_fav',
                  'mulheres_pop_fav_perct',
                  'homens_pop_fav',
                  'homens_pop_fav_perct',
                  'fav_pop_per_dom'
                  ]
       %}
    {% endif %}

    {% if export in ['habitacao-geral','area-geral'] %}
       {% set  campos = '*' %}
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