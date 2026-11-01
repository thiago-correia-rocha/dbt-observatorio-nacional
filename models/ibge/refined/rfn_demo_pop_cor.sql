{{  config(
    tags = ['ibge','demografia','população','cor e raça'],
    s3_data_dir = bucket() ~ '/refined/ibge/parquet/'
) }}
select
    cod as cod_ibge,
    nivel ,
    cep ,
    sigla ,
    cast(total as int) as total,
    cast(branca as int) as branca,
    cast(preta  as int) as preta,
    cast(amarela as int) as amarela,
    cast(parda as int) as parda,
    cast(indigena  as int) as indigena,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('ibge', 'raw_demo_pop_cor') }}