{{
    config(
        tags=['ibge', 'demografia', 'habitação','favela'],
        s3_data_dir = bucket() ~ '/refined/ibge/parquet/'
    )
}}

select
    cod as cod_ibge,
    favela_completa ,
    sigla ,
    favela ,
    municipio ,
    cast(nullif(trim(domicilios),'') as int) as domicilios,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('ibge', 'raw_demo_hab_rel_fav') }}