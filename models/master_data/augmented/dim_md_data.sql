{{
    config(
        tags = ['master data'],
        s3_data_dir = bucket() ~ '/augmented/master_data/parquet/',
    )
}}

select
    cast(data as date) as data,
    cast(trimestre as int) as trimestre,
    cast(ano as int) as ano,
    cast(mes as int) as mes,
    cast(dia as int) as dia,
    dia_semana,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('master_data', 'raw_md_data') }}

