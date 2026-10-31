{{
    config(
        tags=['ibge', 'demografia', 'habitação','favela'],
        s3_data_dir = bucket() ~ '/refined/ibge/parquet/'
    )
}}

select
    cep,
    nivel,
    sigla,
    cast(qtd_favelas as int) as qtd_favelas,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('ibge', 'raw_demo_hab_fav') }}