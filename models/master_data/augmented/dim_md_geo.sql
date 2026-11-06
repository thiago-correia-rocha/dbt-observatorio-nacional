{{
    config(
        tags = ['master data','ibge'],
        s3_data_dir = bucket() ~ '/augmented/master_data/parquet/',
    )
}}

select
    cod_ibge,
    nivel,
    descricao,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('master_data', 'raw_md_geo') }}

