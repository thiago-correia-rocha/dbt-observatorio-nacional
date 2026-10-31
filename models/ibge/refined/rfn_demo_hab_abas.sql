{{
    config(
        tags=['ibge', 'demografia', 'habitação','saneamento','abastecimento'],
        s3_data_dir = bucket() ~ '/refined/ibge/parquet/'
    )
}}

select
    cod as cod_ibge,
    cep,
    nivel,
    sigla,
    existencia,
    cast(total as int) as total,
    cast(rede_geral as int) as rede_geral,
    cast(poco_artesiano as int) as poco_artesiano,
    cast(poco_raso as int) as poco_raso,
    cast(fonte_nascente as int) as fonte_nascente,
    cast(carro_pipa as int) as carro_pipa,
    cast(agua_chuva as int) as agua_chuva,
    cast(rios_acudes as int) as rios_acudes,
    cast(outra as int) as outra,
    abastecimento,
    cast(nullif(ranking,'') as double) as ranking,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('ibge', 'raw_demo_hab_abas') }}