{{  config(
    tags = ['ibge','códigos','demografia'],
    s3_data_dir = bucket() ~ '/refined/'
) }}

select
    nivel,
    cod,
    sigla,
    municipio,
    municipio_c_uf,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('ibge', 'raw_demo_local') }}