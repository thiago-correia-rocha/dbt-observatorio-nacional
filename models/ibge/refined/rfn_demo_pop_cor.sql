{{  config(
    tags = ['ibge','demografia','população','cor e raça'],
    s3_data_dir = bucket() ~ '/refined/ibge/parquet/'
) }}
select
    cod as cod_ibge,
    nivel,
    cast(total as int) as total,
    cast(totalcatolica  as int) as totalcatolica,
    cast(totalevangelica as int) as totalevangelica,
    cast(totalespirita  as int) as totalespirita,
    cast(totalumbanda  as int) as totalumbanda,
    cast(totaltradind  as int) as totaltradind,
    cast(totaloutras  as int) as totaloutras,
    cast(totalateu  as int) as totalateu,
    cast(totalnaosabe  as int) as totalnaosabe,
    cast(totalsd as int) as totalsd,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('ibge', 'raw_demo_rel') }}