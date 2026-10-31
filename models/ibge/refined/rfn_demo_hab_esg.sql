{{
    config(
        tags=['ibge', 'demografia', 'habitação','saneamento','esgoto'],
        s3_data_dir = bucket() ~ '/refined/ibge/parquet/'
    )
}}

select
    cod as cod_ibge,
    cep,
    nivel,
    sigla,
    cast(total as int) as total,
    cast(rede_geral as int) as rede_geral,
    cast(fossa_septica as int) as fossa_septica,
    cast(fossa_rudimentar_buraco as int) as fossa_rudimentar_buraco,
    cast(vala as int) as vala,
    cast(rio_lago_corrego_mar as int) as rio_lago_corrego_mar,
    cast(outra_forma as int) as outra_forma,
    cast(sem_banheiro as int) as sem_banheiro,
    esgoto_perct,
    cast(nullif(ranking,'') as double) as ranking,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('ibge', 'raw_demo_hab_esg') }}