{% macro exporta_ibge_json(table_name) %}

	unload (
        select
            *
        from {{ table_name }}
    )
    to 's3://observatorio-nacional-fs/augmented/ibge/json/{{table_name}}'
    with (
        format = 'json',
        compression = 'none'
    )

{% endmacro %}