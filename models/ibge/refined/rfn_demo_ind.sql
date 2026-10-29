{{  config(
    tags = ['ibge','demografia','povos originários','indígenas'],
    s3_data_dir = bucket() ~ '/refined/ibge/parquet/',
    s3_data_naming = 'table'
) }}

select
    cep	,
    sigla,
    regiao,
    nivel,
    localizacao,
    cast(total   as int) as total,
    cast(homens  as int) as homens,
    cast(mulheres as int) as mulheres,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('ibge', 'raw_demo_ind') }}