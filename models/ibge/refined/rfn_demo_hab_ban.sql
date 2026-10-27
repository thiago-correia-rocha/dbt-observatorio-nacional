{{
    config(
        tags=['ibge', 'demografia', 'habitação','saneamento','banheiro'],
        s3_data_dir = bucket() ~ '/refined/'
    )
}}

select
    cod as cod_ibge,
    cep,
    nivel,
    sigla,
    tipo_esgoto,
    cast(total as int) as total,
    cast(banheiro_exclusivo as int) as banheiro_exclusivo,
    cast(banheiro_uso_comum as int) as banheiro_uso_comum,
    cast(apenas_sanitario as int) as apenas_sanitario,
    cast(sem_banheiro as int) as sem_banheiro,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('ibge', 'raw_demo_hab_ban') }}