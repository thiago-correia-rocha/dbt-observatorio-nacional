{{  config(
    materialized='table',
    tags = ['ibge','códigos','demografia'],
    location = '{{ bucket() }}/refined/ibge/demografia/'
) }}

select
    nivel,
    cod,
    sigla,
    municipio,
    municipio_c_uf
from {{ source('ibge', 'raw_demo_loc') }}