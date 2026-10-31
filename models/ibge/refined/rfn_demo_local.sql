{{  config(
    tags = ['ibge'],
    s3_data_dir = bucket() ~ '/refined/ibge/parquet/'
) }}

select
    nivel,
    cod as cod_ibge,
    sigla,
    municipio,
    municipio_c_uf,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('ibge', 'raw_demo_local') }}