{{
    config(
        tags=['ibge', 'demografia', 'habitação','favela'],
        s3_data_dir = bucket() ~ '/refined/demografia/ibge/parquet/'
    )
}}

select
    cod as cod_ibge,
    municipio_c_uf,
    municipio,
    sigla,
    cast(nullif(trim(domicilios),'') as int) as domicilios,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('demografia', 'raw_ibge_hab_fav_mun') }}
