{{
    config(
        tags=['ibge', 'demografia', 'área' ,'densidade'],
        s3_data_dir = bucket() ~ '/refined/demografia/ibge/parquet/'
    )
}}

select
    cod as cod_ibge,
    cep,
    nivel,
    uf,
    cast(area as double) as area,
    cast(densidade as double) as densidade,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('demografia', 'raw_ibge_area') }}