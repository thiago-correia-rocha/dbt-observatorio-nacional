{{
    config(
        tags=['ibge', 'demografia', 'habitação','saneamento','coleta'],
        s3_data_dir = bucket() ~ '/refined/ibge/parquet/'
    )
}}

select
    cod as cod_ibge,
    cep,
    nivel,
    sigla,
    cast(total as int) as total,
    cast(coletado as int) as coletado,
    cast(queimado as int) as queimado,
    cast(enterrado as int) as enterrado,
    cast(jogado as int) as jogado,
    cast(outro_destino as int) as outro_destino ,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('ibge', 'raw_demo_hab_col') }}