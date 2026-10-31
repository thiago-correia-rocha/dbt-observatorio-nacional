{{
    config(
        tags=['ibge', 'demografia', 'povo originário' ,'quilombola'],
        s3_data_dir = bucket() ~ '/refined/ibge/parquet/'
    )
}}

select
    cod as cod_ibge,
    cep,
    municipio,
    nivel,
    sigla,
    cast(total as int) as  total,
    cast(em_territorio_quilombola as int) as em_territorio_quilombola,
    cast(fora_territorio_quilombola as int) as fora_territorio_quilombola,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('ibge', 'raw_demo_pop_quilo') }}