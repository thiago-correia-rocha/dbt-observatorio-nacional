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
        CREATE EXTERNAL TABLE IF NOT EXISTS master_data.raw_md_geo (
            cod_ibge string,
            nivel string,
            descricao string
        )
        ROW FORMAT SERDE
            'org.apache.hadoop.hive.serde2.OpenCSVSerde'
        WITH SERDEPROPERTIES (
            'separatorChar' = ';',
            'quoteChar' = '"',
            'escapeChar' = '\\'
        )
        STORED AS TEXTFILE
        LOCATION '{{ bucket() }}/raw/master_data/csv/raw_md_geo/'
        TBLPROPERTIES (
            'skip.header.line.count' = '1'
        );
    {% endcall %}

{% endmacro %}
