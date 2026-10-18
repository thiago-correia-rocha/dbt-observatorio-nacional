{{  config(
    materialized='table',
        tags = ['ibge','códigos']
) }}

select
    nivel,
    cod,
    sigla,
    municipio,
    municipio_c_uf
from {{ source('ibge', 'raw_ibge_loc') }}