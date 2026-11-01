{{  config(
    tags = ['ibge','demografia','população','povo originário','indígena'],
    s3_data_dir = bucket() ~ '/refined/demografia/ibge/parquet/'
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
from {{ source('demografia', 'raw_ibge_pop_ind') }}