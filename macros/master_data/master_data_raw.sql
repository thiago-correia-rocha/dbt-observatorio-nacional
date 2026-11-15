{% macro master_data_raw() %}
    {% call statement() %}
        create database if not exists master_data;
    {% endcall %}

    {% call statement() %}
        CREATE EXTERNAL TABLE IF NOT EXISTS master_data.raw_md_data (
            data STRING,
            trimestre STRING,
            ano STRING,
            mes STRING,
            dia STRING,
            dia_semana STRING
        )
        ROW FORMAT SERDE
            'org.apache.hadoop.hive.serde2.OpenCSVSerde'
        WITH SERDEPROPERTIES (
            'separatorChar' = ',',
            'quoteChar' = '"',
            'escapeChar' = '\\'
        )
        STORED AS TEXTFILE
        LOCATION '{{ bucket() }}/raw/master_data/csv/raw_md_data/'
        TBLPROPERTIES (
            'skip.header.line.count' = '1'
        );
    {% endcall %}

    {% call statement() %}
        create external table if not exists master_data.raw_md_geo (
            cod_ibge string,
            nivel string,
            descricao string
        )
        row format serde
            'org.apache.hadoop.hive.serde2.OpenCSVSerde'
        with serdeproperties (
            'separatorChar' = ';',
            'quoteChar' = '"',
            'escapeChar' = '\\'
        )
        stored as textfile
        location '{{ bucket() }}/raw/master_data/csv/raw_md_geo/'
        tblproperties (
            'skip.header.line.count' = '1'
        );
    {% endcall %}

    {% call statement() %}
        create external table if not exists master_data.raw_md_portal (
            id_conteudo string,
            tema string,
            indicador string,
            titulo_principal string,
            texto_principal string,
            titulo_ajuda string,
            texto_ajuda string,
            titulo_importancia string,
            texto_importancia string,
            fonte string,
            url_fonte string,
            url_wiki string,
            url_dashboard string,
            ano_referencia string
        )
        row format serde
            'org.apache.hadoop.hive.serde2.opencsvserde'
        with serdeproperties (
            'separatorChar' = ',',
            'quoteChar' = '"',
            'escapeChar' = '\\'
        )
        stored as textfile
        location '{{ bucket() }}/raw/master_data/csv/raw_md_portal/'
        tblproperties (
            'skip.header.line.count' = '1'
        );
    {% endcall %}

{% endmacro %}
